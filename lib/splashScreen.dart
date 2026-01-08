import 'dart:async';
import 'package:flutter/material.dart';
import 'Login.dart';
class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});
  @override
  State<Splashscreen> createState() => _SplashscreenState();}
class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
            (route) => true,);
    }
    );
    super.initState();}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 43, 40, 40),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage("F:\Gemini.jpg"),
            ),
            Text(
              "الرئيسية",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),

            ),
          ],
        ),
      ),
    );
  }
}
