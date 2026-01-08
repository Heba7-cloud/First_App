import 'package:flutter/material.dart';
import 'package:untitled11/showchats.dart';
import 'Login.dart';


// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// File? _image;
// final ImagePicker _picker = ImagePicker();
//
// Future<void> _pickImage() async {
//   final XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
//
//   if (selectedImage != null) {
//     setState(() {
//       _image = File(selectedImage.path);
//     });
//   }
// }
//
// /(Widget tree):
// // ElevatedButton(onPressed: _pickImage, child: Text("اختار صورة")),
//
// // _image == null ? Text("لم يتم اختيار صورة") : Image.file(_image!),
//
//
//
//


Color h=Colors.black12;

class AddChat extends StatefulWidget {
  State createState() => _AddChat();
}

buildListTile(context,txt,icon) {
  return ListTile(title: Text(txt),
    onTap: () {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => Login(),

          )
      );
      Color c = Colors.white60;

    },

    leading: Icon(icon),
  );

}


class _AddChat extends State{
  Color c=const Color.fromARGB(23, 14, 13, 13);
  TextEditingController chat=TextEditingController();
  List Chats=["New Chat","New Chat"];

  double _currentValue = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.white12,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Gemini',style: TextStyle(color: Colors.white,)),

        backgroundColor: Colors.black12,

      ),

      drawer:Drawer(
        // width: MediaQuery.of(context).size.width/2,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                spacing: 10,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text("Gemini",style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),),
                  )
                ],
              ),
            ),
            buildListTile(context, "Search here", Icons.search),
            buildListTile(context, "New chat", Icons.textsms_outlined),
            buildListTile(context, "Explore Gems", Icons.explore),
          ],

        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.grey,
          backgroundColor: Colors.white12,
          items:
          [
            BottomNavigationBarItem(icon:IconButton(onPressed: (){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Welcome 2 Gemini!")));

            }, icon: Icon(Icons.share_rounded))
                ,label: "Share"),
            BottomNavigationBarItem(icon:Icon(Icons.home),label: "home"),
            BottomNavigationBarItem(icon:Icon(Icons.exit_to_app),label: "Exit")
          ]
      ),
      // drawer:const Mydrawer(),
      body: Column(
// داخل الـ Build Method:
      // عرض القيمة
   children: [ Slider(
    value: _currentValue,
    min: 0,
    max: 100,
    divisions: 10,
    label: _currentValue.round().toString(),
    onChanged: (double newValue) {
    setState(() {
    _currentValue = newValue;
    });

    },
    ),

          Padding(padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: (value) {
                setState(() {
                });
                Chats.add(value);
              },
              controller: chat,
              decoration: InputDecoration(
                labelText: "Ask Gemini",
                hintText: "Ask Gemini",
                fillColor: Colors.amber[108],
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40)),
              ),
            ),
          ),


          ElevatedButton(style: ButtonStyle(backgroundColor:
          WidgetStatePropertyAll(Colors.amber[100],)),
              onPressed: () {
                setState(() {
                });
                if (chat.text.isNotEmpty) {
                  Chats.add(chat.text);
                  chat.clear();
                }
                else
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Ask Gemini:")));
              },
              child: Text("New Chat")),
    ElevatedButton(
    style:ButtonStyle(backgroundColor: WidgetStatePropertyAll(c)
    ),
    onPressed: () {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Showchats(chatsInfo: [])),
    );
    },
    child: Text("Show Chats"),
    ),
          Expanded(
            child: ListView.builder(
              itemCount: Chats.length,
              itemBuilder: (context, i) =>
                  Card(
                    color: c,
                    child: ListTile(
                      onTap: () {
                        chat.text = Chats[i];
                      },
                      leading: IconButton(onPressed: () {
                        Chats.removeAt(i);
                        setState(() {
                        });
                      }, icon: Icon(Icons.delete, color:  Colors.white60,)),
                      trailing: IconButton(onPressed: () {
                        Chats[i] = chat.text;
                        setState(() {
                        });
                      }, icon: Icon(Icons.edit, color:  Colors.white60,)),
                      title: Text(Chats[i], textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white60),),

                    ),
                  ),
            ),

          ),

]      ),

    );
  }
}
