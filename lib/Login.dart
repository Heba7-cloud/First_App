import 'package:flutter/material.dart';
import 'showchats.dart';
import 'AddChat.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();}
class _LoginState extends State<Login> {




  Color c = Colors.white60;

  TextEditingController _name = TextEditingController();
  TextEditingController _password = TextEditingController();

  double result = 0.0;

  @override

  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: Colors.black12,
      appBar: AppBar(title: const Text("Log in")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: _name,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: const BorderSide(
                    color: Colors.white60,
                    style: BorderStyle.solid,
                    width: 5,
                  ),
                ),
                filled: true,
                fillColor: c,
                labelText: "Name",
                hintText:"input your name plz",
                prefixIcon: Icon(Icons.person),

              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(7.0),
            child: TextField(
              controller: _password,
              keyboardType: TextInputType.number,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: BorderSide(
                    color: Colors.white60,
                    style: BorderStyle.solid,
                    width: 5,
                  ),
                ),
                filled: true,
                fillColor: Colors.black12,
                labelText: "Password",
                hintText: "Input your password",
                prefixIcon: Icon(Icons.lock),
              ),
            ),
          ),

          SizedBox(height: 10),

          Text("Result = $result"),

          ElevatedButton(
            style:ButtonStyle(backgroundColor: WidgetStatePropertyAll(c)
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddChat()),
              );
              setState(() { });
              result=double.parse(_name.text)+double.parse(_password.text);
            },
            child: Text("Log in!"),
          ),

        ],
      ),
    );
  }
}
