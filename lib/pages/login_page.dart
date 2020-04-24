import 'package:Passwall/antenna.dart';
import 'package:Passwall/pages/list_page.dart';
import 'package:Passwall/localization/localization.dart';
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
        child: Center(
          child: SizedBox(
            width: 400,
            child: ListView(
              padding: EdgeInsets.all(40),
              children: <Widget>[
                textField(
                  controller: baseUrlController,
                  autoFocus: false,
                  obscure: false,
                  label: AppLocalizations.of(context).trans('base_URL'),
                  hint: "https://my.server.com:3625",
                  icon: Icon(Icons.language),
                  i: 0,
                ),
                SizedBox(height: 10),
                textField(
                  autoFocus: true,
                  obscure: false,
                  label: AppLocalizations.of(context).trans('username'),
                  icon: Icon(Icons.perm_identity),
                  i: 1,
                ),
                SizedBox(height: 10),
                textField(
                  autoFocus: false,
                  obscure: true,
                  label: AppLocalizations.of(context).trans('password'),
                  icon: Icon(Icons.lock_outline),
                  i: 2,
                ),
                SizedBox(height: 10),
                FlatButton(
                  child: Text(AppLocalizations.of(context).trans('login')),
                  onPressed: () {
                    login();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  login() {
    Antenna().login(username, password, baseURL).then((success) {
      if (success) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new ListPage()));
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
            title: Text(AppLocalizations.of(context).trans('swr')),
            content: Text(AppLocalizations.of(context).trans('swr_')),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context).trans('ok')),
              )
            ],
          );
        });
  }
}
