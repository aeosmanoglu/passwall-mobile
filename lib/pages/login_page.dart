import 'home_page.dart';
import 'package:Passwall/utils/antenna.dart';
import 'package:Passwall/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _baseUrlController = TextEditingController();
  String _baseURL, _username, _password;

  Widget _textField({
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
              _baseURL = text;
              break;
            }
          case 1:
            {
              _username = text;
              break;
            }
          case 2:
            {
              _password = text;
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

  _getBaseURL() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _baseURL = preferences.getString("server");
    setState(() {
      _baseUrlController.text = _baseURL;
    });
  }

  @override
  void initState() {
    _getBaseURL();
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
                _textField(
                  controller: _baseUrlController,
                  autoFocus: false,
                  obscure: false,
                  label: AppLocalizations.of(context).trans('base_URL'),
                  hint: "https://my.server.com:3625",
                  icon: Icon(Icons.language),
                  i: 0,
                ),
                SizedBox(height: 10),
                _textField(
                  autoFocus: true,
                  obscure: false,
                  label: AppLocalizations.of(context).trans('username'),
                  icon: Icon(Icons.perm_identity),
                  i: 1,
                ),
                SizedBox(height: 10),
                _textField(
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
                    _login();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _login() {
    Antenna().login(_username, _password, _baseURL).then((success) {
      (success) ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new HomePage())) : _dialog();
    });
  }

  void _dialog() {
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
            ),
          ],
        );
      },
    );
  }
}
