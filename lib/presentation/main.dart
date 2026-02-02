import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled11/presentation/AddChat.dart';
import 'package:untitled11/presentation/Login.dart';
import 'package:untitled11/presentation/splashScreen.dart';
import '../core/app_controller.dart';
import '../core/messages.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async{
  // استخدام التبعيات بشكل سليم
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(AppController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gemini App',

      // 1. إعدادات الترجمة
      translations: Messages(),
      locale: const Locale('ar'),
      fallbackLocale: const Locale('en'),
initialRoute: '/',
getPages: [
  GetPage(name: '/AddChat', page: ()=>AddChat())
],

      // 2. الثيم الفاتح (Light Mode)
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
        ),
        textTheme: GoogleFonts.notoKufiArabicTextTheme(ThemeData.light().textTheme),
      ),

      // 3. الثيم الداكن (Dark Mode) - هذا ما كان ينقصك!
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF121212), // أسود مريح للعين
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
        ),
        // تفعيل الخط العربي للوضع الليلي أيضاً
        textTheme: GoogleFonts.notoKufiArabicTextTheme(ThemeData.dark().textTheme),
      ),

      // 4. وضع الثيم (يتبع النظام أو يتغير يدوياً عبر Get.changeThemeMode)
      themeMode: ThemeMode.system,

      home: Splashscreen(),
    );
  }
}