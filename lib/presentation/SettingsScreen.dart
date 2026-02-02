import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/app_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // العثور على الكنترولر
    final AppController controller = Get.find<AppController>();

    return Scaffold(
      appBar: AppBar(
        title: Text("settings".tr),
        centerTitle: true,
      ),
      // الـ ListView كأب مباشر يحل مشكلة الـ RenderBox تماماً
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        children: [

          // --- قسم التفضيلات (Preferences) ---
          _buildSectionTitle("preferences".tr),

          ListTile(
            leading: const Icon(Icons.language, color: Colors.blueAccent),
            title: Text("language".tr),
            subtitle: Text(Get.locale?.languageCode == 'ar' ? "العربية" : "English"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {
              if (Get.locale?.languageCode == 'ar') {
                controller.changeLanguage('en');
              } else {
                controller.changeLanguage('ar');
              }
            },
          ),


          ListTile(
            leading: const Icon(Icons.dark_mode_outlined, color: Colors.orange),
            title: Text("Dark mode".tr,),
            onTap: () => Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark),
          ),

          const Divider(height: 30),

          // --- قسم إدارة البيانات (Data Management) ---
          _buildSectionTitle("data_management".tr),

          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
            title: Text("clear_all_chats".tr, style: const TextStyle(color: Colors.redAccent)),
            subtitle: Text("delete_all_history_warning".tr),
            onTap: () {
              Get.defaultDialog(
                title: "confirm_delete".tr,
                middleText: "are_you_sure_delete_all".tr,
                textConfirm: "yes_delete".tr,
                textCancel: "cancel".tr,
                confirmTextColor: Colors.white,
                buttonColor: Colors.redAccent,
                onConfirm: () {
                  controller.clearAllChats();
                  Get.back();
                },
              );
            },
          ),

          const Divider(height: 30),

          // --- قسم عن التطبيق ---
          _buildSectionTitle("about_app".tr),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("Gemini AI Version"),
            subtitle: const Text("1.0.0"),
            onTap: () {
              Get.snackbar("Info", "Developed by Software Engineering Student");
            },
          ),
        ],
      ),
    );
  }

  // دالة مساعدة لرسم عناوين الأقسام
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }
}