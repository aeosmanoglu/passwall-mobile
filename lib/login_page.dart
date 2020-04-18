import 'package:Passwall/antenna.dart';
import 'package:Passwall/home_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController baseUrlController = TextEditingController();
  String baseURL, username, password;

  Widget textField({
    TextEditingController controller,
    bool autoFocus,
    bool obscure,
    String label,
    String hint,
    Icon icon,
    int i,
  }) {
    return TextField(
      controller: controller,
      autocorrect: false,
      autofocus: autoFocus,
      obscureText: obscure,
      onChanged: (text) {
        switch (i) {
          case 0:
            {
              baseURL = text;
              break;
            }
          case 1:
            {
              username = text;
              break;
            }
          case 2:
            {
              password = text;
              break;
            }
        }
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
        hintText: hint,
        prefixIcon: icon,
      ),
    );
  }

  getBaseURL() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    baseURL = preferences.getString("server");
    setState(() {
      baseUrlController.text = baseURL;
    });
  }

  @override
  void initState() {
    getBaseURL();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            textField(
              controller: baseUrlController,
              autoFocus: false,
              obscure: false,
              label: "Base URL",
              hint: "https://my.server.com:3625",
              icon: Icon(Icons.language),
              i: 0,
            ),
            SizedBox(height: 10),
            textField(
              autoFocus: true,
              obscure: false,
              label: "Username",
              icon: Icon(Icons.perm_identity),
              i: 1,
            ),
            SizedBox(height: 10),
            textField(
              autoFocus: false,
              obscure: true,
              label: "Password",
              icon: Icon(Icons.lock_outline),
              i: 2,
            ),
            SizedBox(height: 10),
            FlatButton(
              child: Text("LOG IN"),
              onPressed: () {
                login();
              },
            )
          ],
        ),
      ),
    );
  }

  login() {
    Antenna().login(username, password, baseURL).then((success) {
      if (success) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new HomePage()));
      } else {
        dialog();
      }
    });
  }

  void dialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Something went wrong"),
            content: Text("Please check your username, password or base URL again"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              )
            ],
          );
        });
  }
}
