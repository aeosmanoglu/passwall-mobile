import 'package:Passwall/antenna.dart';
import 'package:Passwall/home_page.dart';
import 'package:Passwall/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Gate(),
    );
  }
}

class Gate extends StatefulWidget {
  @override
  _GateState createState() => _GateState();
}

class _GateState extends State<Gate> {
  @override
  Widget build(BuildContext context) {
    // Check the user authorized or not
    getToken().then((token) => router(token));

    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Future<String> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token");
    return token;
  }

  router(String token) {
    Antenna().gateKeeper(token).then((success) {
      if (success) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new HomePage()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new LoginPage()));
      }
    });
  }
}
