import 'package:flutter/material.dart';
import'AddChat.dart';
class Showchats extends StatelessWidget {
  const Showchats({super.key, required this.chatsInfo});
  final List chatsInfo;

  @override

  Widget build(BuildContext context) {

    Color c = Colors.white60;
    return Scaffold(
      backgroundColor: Colors.white60,
      appBar: AppBar(
        title: const Text("Chats List"),
      ),

      body:
      // ElevatedButton(
      // style:ButtonStyle(backgroundColor: WidgetStatePropertyAll(c)
      //   ),
      //   onPressed: () {
      //     Navigator.push(context, MaterialPageRoute(builder: (context)=>AddChat()),
      //     );
      //   },
      //   child: Text("Show Chats"),
      // );
      ListView.builder(
        itemCount: chatsInfo.length,
        itemBuilder: (context, i) => Center(
          child: ListTile(
            title: Text(chatsInfo[i]),
          ),
        ),

      ),
    );

  }
}
