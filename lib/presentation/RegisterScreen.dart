import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../core/app_controller.dart';
import 'Login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // استخدام Get.find للوصول للكنترولر المشغل مسبقاً
  final AppController controller = Get.find<AppController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  File? userImage;

  // دالة اختيار الصورة من المعرض
  Future<void> pickUserImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        userImage = File(image.path);
        // تحديث مسار الصورة في الكنترولر ليتم عرضها في البروفايل والدراور
        controller.currentUserImage.value = image.path;
      });
    }
  }

  // دالة إنشاء الحساب والحفظ في sqflite
  void register() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      // استدعاء دالة الحفظ في قاعدة البيانات الموجودة في الـ AppController
      await controller.registerUser(name, email, password,userImage!.path);

      // إظهار رسالة نجاح (مترجمة)
      Get.snackbar(
        "succ".tr,
        "ms1".tr,
        backgroundColor: Colors.green.withOpacity(0.7),
        colorText: Colors.white,
      );

      String imagePath=userImage?.path??"";
      await controller.registerUser(name, email, password,imagePath);
      // الانتقال لصفحة تسجيل الدخول
      Get.off(() => const Login());
    } else {
      Get.snackbar(
        "succ".tr,
        "ms1".tr,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create an account'.tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // قسم اختيار الصورة
            GestureDetector(
              onTap: pickUserImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.blue.shade100,
                    backgroundImage: userImage != null ? FileImage(userImage!) : null,
                    child: userImage == null
                        ? const Icon(Icons.person, size: 60, color: Colors.blueAccent)
                        : null,
                  ),
                  const CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    radius: 18,
                    child: Icon(Icons.add_a_photo, size: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            TextField(
                controller: nameController,
                decoration: InputDecoration(labelText:'Fname'.tr, border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))))
            ),
            const SizedBox(height: 15),

            TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'.tr, border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))))
            ),
            const SizedBox(height: 15),

            TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'.tr, border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(15))))
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text('create_acc'.tr, style: const TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}