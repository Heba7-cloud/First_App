import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/app_controller.dart';
import 'AddChat.dart';
import 'RegisterScreen.dart';
import '../data/models/user_model.dart'; // تأكدي أن المسار صحيح لمجلد الموديل

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // استدعاء الكنترولر المشغل مسبقاً في التطبيق
  final AppController controller = Get.find<AppController>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() {
    String inputEmail = emailController.text.trim();
    String inputPass = passwordController.text.trim();

    // البحث في قائمة المستخدمين القادمة من قاعدة البيانات (usersList)
    // لاحظي استخدام .password و .email لأننا نستخدم Object من UserModel
    var userFound = controller.usersList.firstWhere(
          (u) => u.email == inputEmail && u.password == inputPass,
      orElse: () => UserModel(id: "", name: "", email: "", password: ""),
    );

    if (userFound.id != -1) {
      // تحديث بيانات المستخدم الحالي في الكنترولر لعرضها في الدراور والبروفايل
      controller.updateUserData(userFound.name, userFound.email, userFound.id.toString());

      // إذا كانت هناك صورة مخزنة في قاعدة البيانات للمستخدم، نقوم بتحديثها أيضاً
      // controller.currentUserImage.value = userFound.imagePath ?? "";

      Get.offAll(() => const AddChat()); // الانتقال لواجهة الشات

      Get.snackbar(
        "succ".tr,
        "ms1".tr,
        backgroundColor: Colors.green.withOpacity(0.7),
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "warnin".tr,
        "ms3".tr,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_person, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 20),
              Text(
                "Login to Gemini".tr,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // حقل البريد
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email".tr,
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 15),

              // حقل كلمة السر
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password".tr,
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 25),

              // زر الدخول المعدل ليتناسب مع Firebase
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // التأكد من أن المستخدم أدخل بيانات قبل الاتصال بالفايربيس
                    if (emailController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
                      Get.snackbar(
                        "warnin".tr,
                        "ms2".tr,
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.redAccent.withOpacity(0.7),
                        colorText: Colors.white,
                      );
                    } else {
                      // استدعاء دالة الفايربيس الموجودة في الكنترولر
                      controller.login(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(
                    "Log In".tr,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // رابط إنشاء حساب جديد
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("nocc".tr),
                  GestureDetector(
                    onTap: () => Get.to(() => const RegisterScreen()),
                    child: Text(
                      "Create an account".tr,
                      style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}