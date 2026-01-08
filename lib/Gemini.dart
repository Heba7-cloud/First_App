// import 'package:flutter/material.dart';
// import'AddChat.dart';
//
//
// class Gemini extends StatelessWidget {
//   const Gemini({super.key});
//
// buildListTile(context,txt,icon) {
//   return ListTile(title: Text(txt),
//     onTap: () {
//       Navigator.of(context).push(
//           MaterialPageRoute(builder: (context) => Gemini(),
//
//           )
//       );
//     },
//     leading: Icon(icon),
// );
// }
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//
//       backgroundColor: Colors.white12,
//       appBar: AppBar(
// centerTitle: true,
//         title: const Text('Gemini',style: TextStyle(color: Colors.white,),
//       ),
//           backgroundColor: Colors.black12,
//       ),
//       drawer:Drawer(
//         // width: MediaQuery.of(context).size.width/2,
//         child: ListView(
//           children: [
// DrawerHeader(
//   decoration: BoxDecoration(color: Colors.white),
//   child: Column(
//     spacing: 10,
//     children: [
//       Expanded(
// flex: 2,
// child: Text("Gemini",style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),),
//       )
//     ],
//   ),
// ),
//             buildListTile(context, "Search here", Icons.search),
//             buildListTile(context, "New chat", Icons.textsms_outlined),
//             buildListTile(context, "Explore Gems", Icons.explore),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//           selectedItemColor: Colors.grey,
//           backgroundColor: Colors.white12,
//           items:
//       [
//         BottomNavigationBarItem(icon:IconButton(onPressed: (){
//           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Welcome 2 Gemini!")));
//
//         }, icon: Icon(Icons.share_rounded))
//             ,label: "Share"),
//         BottomNavigationBarItem(icon:Icon(Icons.home),label: "home"),
//         BottomNavigationBarItem(icon:Icon(Icons.exit_to_app),label: "Exit")
//       ]
//       ),
//     );
//   }
// }