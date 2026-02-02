import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/app_controller.dart';
import 'Login.dart';
import 'SettingsScreen.dart';
import 'ProfileScreen.dart';

class AddChat extends StatefulWidget {
  const AddChat({super.key});
  @override
  State<AddChat> createState() => _AddChatState();
}

class _AddChatState extends State<AddChat> {
  final AppController controller = Get.find();
  final TextEditingController chatController = TextEditingController();
  File? selectedImage;
  final user = FirebaseAuth.instance.currentUser;

  // --- دالة اختيار صورة ---
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
      Get.snackbar("success".tr, "image_selected".tr,
          backgroundColor: Colors.green.withOpacity(0.5),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // --- دالة المساعدة ---
  void showHelpSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("help".tr, style: GoogleFonts.notoKufiArabic(fontSize: 20, fontWeight: FontWeight.bold)),
            const Divider(),
            ListTile(leading: const Icon(Icons.chat), title: Text("how_start".tr, style: GoogleFonts.notoKufiArabic())),
            ListTile(leading: const Icon(Icons.image), title: Text("how_image".tr, style: GoogleFonts.notoKufiArabic())),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: () => Get.back(), child: Text("close".tr, style: GoogleFonts.notoKufiArabic())),
          ],
        ),
      ),
    );
  }

  // --- دالة الملاحظات ---
  void showFeedbackSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("feedback".tr, style: GoogleFonts.notoKufiArabic(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
                decoration: InputDecoration(
                    hintText: "ask".tr,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                )
            ),
            const SizedBox(height: 15),
            ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.snackbar("success".tr, "feedback_sent".tr);
                },
                child: Text("send".tr, style: GoogleFonts.notoKufiArabic())
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle arabicStyle = GoogleFonts.notoKufiArabic();

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('gemini'.tr, style: GoogleFonts.notoKufiArabic(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Builder(builder: (context) => IconButton(
            icon: Obx(() => CircleAvatar(
              radius: 15,
              backgroundImage: controller.currentUserImage.value.isNotEmpty
                  ? FileImage(File(controller.currentUserImage.value))
                  : null,
              child: controller.currentUserImage.value.isEmpty ? const Icon(Icons.person, size: 20) : null,
            )),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          )),
        ],
      ),

      // --- الدروار الأيسر (سجل المحادثات المعدل) ---
      // --- الدروار الأيسر (سجل المحادثات مثل Gemini) ---
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.grey[800]),
              child: Center(
                  child: Text(
                      "show_chats".tr,
                      style: arabicStyle.copyWith(color: Colors.white, fontSize: 18)
                  )
              ),
            ),

            // زر محادثة جديدة
            ListTile(
              leading: const Icon(Icons.add_circle_outline, color: Colors.blueAccent),
              title: Text("new_chat".tr, style: arabicStyle),
              onTap: () {
                // حفظ المحادثة الحالية قبل مسحها للبدء من جديد
                controller.saveCurrentChatToHistory();
                controller.messagesList.clear();

                Get.back();
              },
            ),

            const Divider(), // خط فاصل بين الزر والسجل

            // سجل المحادثات مع ميزة الفتح والحذف
            Expanded(
              child: Obx(() {
                return ListView.builder(
                  itemCount: controller.chatsList.length,
                  itemBuilder: (context, index) {
                    final chat = controller.chatsList[index];
                    return ListTile(
                      leading: const Icon(Icons.chat_bubble_outline, size: 20),
                      title: Text(
                        chat.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: arabicStyle.copyWith(fontSize: 14),
                      ),
                      // أيقونة الحذف جهة اليسار (أو اليمين حسب اللغة)
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_sweep, color: Colors.redAccent, size: 20),
                        onPressed: () {
                          // استدعاء دالة الحذف (سأضيفها لكِ في الكنترولر بالأسفل)
                          controller.deleteChat(chat.id!);
                        },
                      ),
                      onTap: () async {
                        // فتح المحادثة القديمة
                        await controller.fetchMessagesForChat(chat.id!);
                        Get.back(); // إغلاق الدراور بعد الاختيار
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      // --- الدروار الأيمن (الملف الشخصي والإعدادات) ---
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Obx(() => UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.grey[850]),
              accountName: Text(controller.currentUserName.value, style: arabicStyle),
              accountEmail: Text(user?.email ?? "No email".tr),
              currentAccountPicture: CircleAvatar(
                backgroundImage: controller.currentUserImage.value.isNotEmpty
                    ? FileImage(File(controller.currentUserImage.value))
                    : null,
                child: controller.currentUserImage.value.isEmpty ? const Icon(Icons.person, size: 40) : null,
              ),
            )),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: Text("Profile".tr, style: arabicStyle),
              onTap: () {
                Get.back();
                Get.to(() => ProfileScreen());
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text("language".tr, style: arabicStyle),
              onTap: () {
                var locale = Get.locale?.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
                Get.updateLocale(locale);
              },
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: Text("theme".tr, style: arabicStyle),
              onTap: () => Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.grey),
              title: Text("settings".tr, style: arabicStyle),
              onTap: () {
                Get.back();
                Get.to(() => const SettingsScreen());
              },
            ),
            ListTile(leading: const Icon(Icons.feedback_outlined), title: Text("feedback".tr, style: arabicStyle), onTap: showFeedbackSheet),
            ListTile(leading: const Icon(Icons.help_outline), title: Text("help".tr, style: arabicStyle), onTap: showHelpSheet),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text("logout".tr, style: arabicStyle),
              onTap: () {
                controller.messagesList.clear();
                controller.historyChats.clear();
                Get.offAll(() => const Login());
              },
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 10),
          CarouselSlider(
            options: CarouselOptions(height: 50.0, autoPlay: true),
            items: [
              Center(child: Text("ask".tr, style: arabicStyle)),
              Center(child: Text("Gemini AI Active", style: arabicStyle)),
            ],
          ),

          if (selectedImage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(selectedImage!, height: 100, width: 100, fit: BoxFit.cover),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    onPressed: () => setState(() => selectedImage = null),
                  )
                ],
              ),
            ),

          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: controller.messagesList.length,
              itemBuilder: (context, i) => ListTile(
                title: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Get.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(controller.messagesList[i].content,
                      style: arabicStyle.copyWith(color: context.theme.textTheme.bodyLarge?.color)),
                ),
              ),
            )),
          ),

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                color: Get.isDarkMode ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  IconButton(
                      onPressed: pickImage,
                      icon: const Icon(Icons.add_photo_alternate, color: Colors.blueAccent)
                  ),
                  Expanded(
                    child: TextField(
                      controller: chatController,
                      style: arabicStyle,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "ask".tr,
                          hintStyle: arabicStyle,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10)
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (chatController.text.isNotEmpty) {
                        controller.sendMessage(chatController.text, 1);
                        chatController.clear();
                        setState(() => selectedImage = null);
                      }
                    },
                    icon: const Icon(Icons.send, color: Colors.blueAccent),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}