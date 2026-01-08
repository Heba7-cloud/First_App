import 'package:flutter/material.dart';
// import 'AddChat.dart';
// import 'showchats.dart';
// import 'Login.dart';
import 'splashScreen.dart';
// import 'RegisterScreen.dart';
// import 'Tools.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      home: Splashscreen(),
      // initialRoute:'',
      // routes: {
      // '/splashScreen': (context) => Splashscreen(),
      //   '/':(context) => Login(),
      //   '/AddChats': (context) => AddChat(),
      //   '/Showchats': (context) => const Showchats(chatsInfo: []),
      //   '/RegisterScreen':(context) => RegisterScreen(),
      //   '/Tools':(context)=>tools(),
      // }
    );
  }
}


