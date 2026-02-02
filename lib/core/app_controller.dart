import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled11/presentation/Login.dart';

import '../data/models/user_model.dart';
import '../data/models/chat_model.dart';
import '../data/models/message_model.dart';

class AppController extends GetxController {
  var historyChats = <String>[].obs;
  var currentUserName = "".obs;
  var currentUserEmail = "".obs;
  var currentUserImage = "".obs;

  // تم التغيير لـ String ليتوافق مع Firebase UID
  var currentUserId = "".obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rxn<User> firebaseUser = Rxn<User>();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  var usersList = <UserModel>[].obs;
  var chatsList = <ChatModel>[].obs;
  var messagesList = <MessageModel>[].obs;

  Database? _db;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    firebaseUser.bindStream(_auth.authStateChanges());
    initDb();
  }

  Future<void> initDb() async {
    String path = join(await getDatabasesPath(), 'gemini_final.db');

    _db = await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE users (
          id TEXT PRIMARY KEY, 
          name TEXT, email TEXT, password TEXT, imagePath TEXT
        )''');

      await db.execute('''
        CREATE TABLE chats (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          title TEXT, user_id TEXT,
          FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
        )''');

      await db.execute('''
        CREATE TABLE messages (
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          content TEXT, chat_id INTEGER,
          FOREIGN KEY (chat_id) REFERENCES chats (id) ON DELETE CASCADE
        )''');
    });
    fetchUsers();
  }

  Future<void> updateFullProfile() async {
    await _db?.update(
      'users',
      {
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'imagePath': currentUserImage.value,
      },
      where: 'id = ?',
      whereArgs: [currentUserId.value],
    );

    currentUserName.value = nameController.text;
    currentUserEmail.value = emailController.text;

    Get.snackbar("succ".tr, "save".tr);
  }

  Future<void> saveCurrentChatToHistory() async {
    // إذا الشاشة فاضية لا تسوي شيء
    if (messagesList.isEmpty) return;

    try {
      // 1. خذي أول رسالة عشان تكون هي "العنوان" في الدراور
      String firstMessage = messagesList.first.content;
      String chatTitle = firstMessage.length > 25 ? firstMessage.substring(0, 25) + "..." : firstMessage;

      // 2. احفظي "رأس المحادثة" في جدول chats
      int newChatId = await _db?.insert('chats', {
        'title': chatTitle,
        'user_id': currentUserId.value,
      }) ?? 0;

      // 3. احفظي كل الرسائل اللي في الشاشة الآن واربطيها بهذا الـ ID
      if (newChatId != 0) {
        for (var msg in messagesList) {
          await _db?.insert('messages', {
            'content': msg.content,
            'chat_id': newChatId,
          });
        }
      }

      // 4. السطر السحري: اطلبي من الداتابيز كل المحادثات وحدثي القائمة اللي يشوفها الدراور
      final List<Map<String, dynamic>> maps = await _db?.query(
          'chats',
          where: 'user_id = ?',
          whereArgs: [currentUserId.value]
      ) ?? [];

      // التحديث الفوري للقائمة المرئية
      chatsList.assignAll(maps.map((data) => ChatModel.fromMap(data)).toList());

      // 5. الحين صفي الشاشة عشان يبدأ المستخدم من جديد
      messagesList.clear();

      Get.snackbar("تم الحفظ", "تمت إضافة المحادثة إلى السجل");
    } catch (e) {
      print("Error saving chat: $e");
    }
  }

  Future<void> updateProfileImage(String path) async {
    await _db?.update('users', {'imagePath': path}, where: 'id = ?', whereArgs: [currentUserId.value]);
    currentUserImage.value = path;
  }

  // تعديل النوع هنا لـ String
  void updateUserData(String name, String email, String id) {
    currentUserName.value = name;
    currentUserEmail.value = email;
    currentUserId.value = id;
    nameController.text = name;
    emailController.text = email;
  }
  Future<void> registerUser(String name, String email, String password,String imagePath) async {
    try {
      // 1. إنشاء الحساب في فايربيس أولاً (هذا هو الربط الحقيقي)
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),

      );
      // 2. الآن نأخذ الـ UID الحقيقي الذي ولّده فايربيس
      String uid = userCredential.user!.uid;
      // 3. نحفظ هذا الـ UID في SQLite ليرتبط الحساب المحلي بالسحابي
      await _db?.insert('users', {
        'id': uid,
        'name': name,
        'email': email,
        'password': password,
        'image': imagePath,
      }
      );
      // 4. تحديث البيانات في التطبيق
      updateUserData(name, email, uid);
      await fetchUsers();

      Get.offAllNamed('/Login'); // توجيه المستخدم للرئيسية بعد النجاح

    } catch (e) {
      // إذا حدث خطأ (مثلاً الإيميل مستخدم مسبقاً)
      print("Database ms:$e");
      Get.snackbar("login".tr,"");
    }
  }
  Future<void> fetchUsers() async {
    final List<Map<String, dynamic>> maps = await _db?.query('users') ?? [];
    usersList.assignAll(maps.map((data) => UserModel.fromMap(data)).toList());
  }

  Future<void> addNewChat(String title, String userId) async {
    await _db?.insert('chats', {'title': title, 'user_id': userId});
    await fetchChatsForUser(userId); // هذه بتجيب البيانات الجديدة فوراً للدراور
  }

  // 1. عند جلب المحادثات: تأكدي أننا نجلب فقط محادثات الـ ID الحالي
  Future<void> fetchChatsForUser(String userId) async {
    if (userId.isEmpty) return;

    final List<Map<String, dynamic>> maps = await _db?.query(
        'chats',
        where: 'user_id = ?',
        whereArgs: [userId]
    ) ?? [];

    // assignAll تمسح القديم وتضع الجديد فقط (تمنع الرصرصة)
    chatsList.assignAll(maps.map((data) => ChatModel.fromMap(data)).toList());
  }

// 2. دالة تنظيف شاملة (استدعيها عند تسجيل الخروج أو تبديل المستخدم)
  void clearUserData() {
    messagesList.clear();
    chatsList.clear();
    currentUserId.value = "";
    currentUserName.value = "";
  }

  Future<void> sendMessage(String content, int chatId) async {
    await _db?.insert('messages', {'content': content, 'chat_id': chatId});
    await fetchMessagesForChat(chatId);
  }

  Future<void> fetchMessagesForChat(int chatId) async {
    final List<Map<String, dynamic>> maps = await _db?.query('messages', where: 'chat_id = ?', whereArgs: [chatId]) ?? [];
    messagesList.assignAll(maps.map((data) => MessageModel.fromMap(data)).toList());
  }

  Future<void> openExistingChat(int chatId) async {
    await fetchMessagesForChat(chatId);
  }

  // دالة حذف محادثة نهائياً من قاعدة البيانات
  Future<void> deleteChat(int chatId) async {
    await _db?.delete(
      'chats',
      where: 'id = ?',
      whereArgs: [chatId],
    );
    // تحديث القائمة في الواجهة فوراً
    await fetchChatsForUser(currentUserId.value);

    Get.snackbar("تنبيه", "تم حذف المحادثة بنجاح",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.1)
    );
  }

  Future<void> clearAllChats() async {
    await _db?.delete('chats', where: 'user_id = ?', whereArgs: [currentUserId.value]);
    chatsList.clear();
    historyChats.clear();
    messagesList.clear();
    Get.snackbar("del".tr, "delch".tr);
  }

  void clearChatList() {
    messagesList.assignAll([]);
    historyChats.assignAll([]);

    update();
  }

  void changeLanguage(String code) {
    Get.updateLocale(Locale(code));
  }

  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password.trim()
      );

      // الآن المعرف نصي تماماً ولا يوجد تعارض
      currentUserId.value = userCredential.user!.uid;

      // جلب بياناته المحلية بناءً على الـ UID
      await fetchChatsForUser(currentUserId.value);

      Get.offAllNamed('/AddChat');
    } catch (e) {
      Get.snackbar("error".tr, "login_failed".tr);
    }
  }

  void logoutWithFirebase() async {
    await _auth.signOut();
    clearChatList();
    Get.offAll(() => const Login());
  }
}