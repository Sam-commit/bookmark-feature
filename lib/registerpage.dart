import 'package:flutter/material.dart';
import 'package:bookmark_items/functions.dart';
import 'package:bookmark_items/homepage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  Functions func = Functions();

  String email="";
  String password="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register"),),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              email = value;
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: "email"),
          ),
          TextField(
            onChanged: (value) {
              password = value;
            },
            obscureText: true,
            decoration: InputDecoration(hintText: "password"),
          ),
          TextField(
            onChanged: (value) {
              password = value;
            },
            obscureText: true,
            decoration: InputDecoration(hintText: "confirm password"),
          ),
          ElevatedButton(
              onPressed: () async {
                if (await func.register(email, password)) {
                  await func.getitems();
                  print(func.bookmarks);
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePage()), (route) => false);
                }
                else {
                  print("Error in Registration");
                }
              },
              child: Text("Register")),
        ],
      ),
    );
  }
}
