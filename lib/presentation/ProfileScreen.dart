import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled11/presentation/AddChat.dart';
import '../core/app_controller.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final AppController controller = Get.find<AppController>();

  Future<void> changeProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      controller.currentUserImage.value = image.path;
      controller.updateProfileImage(image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile".tr)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Obx(() => GestureDetector(
                onTap: changeProfileImage,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.grey[300],
                      key: ValueKey(controller.currentUserImage.value),
                      backgroundImage: controller.currentUserImage.value.isNotEmpty
                          ? FileImage(File(controller.currentUserImage.value))
                          : null,
                      child: controller.currentUserImage.value.isEmpty
                          ? const Icon(Icons.person, size: 70, color: Colors.white)
                          : null,
                    ),
                    const CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      radius: 20,
                      child: Icon(Icons.edit, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 30),

              TextField(
                controller: controller.nameController,
                decoration: InputDecoration(
                  labelText: "Name".tr,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: controller.emailController,
                decoration: InputDecoration(
                  labelText: "Email".tr,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 25),
              TextField(
                controller: controller.passwordController,
                decoration: InputDecoration(
                  labelText: "Password".tr,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.password),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await controller.updateFullProfile();
                    Get.to(() => AddChat());
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Save Changes".tr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}