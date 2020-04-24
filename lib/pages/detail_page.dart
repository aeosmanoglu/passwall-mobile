import 'package:Passwall/antenna.dart';
import 'package:Passwall/localization/localization.dart';
import 'package:Passwall/objects.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final Credential credential;

  DetailPage(this.credential);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController urlController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String url, username, password;

  @override
  void initState() {
    urlController.text = widget.credential.url;
    usernameController.text = widget.credential.username;
    passwordController.text = widget.credential.password;
    url = widget.credential.url;
    username = widget.credential.username;
    password = widget.credential.password;
    super.initState();
  }

  Widget textField({
    String font,
    TextEditingController controller,
    String label,
    Icon icon,
    String help,
    int i,
  }) {
    return TextField(
      style: TextStyle(fontFamily: font),
      autocorrect: false,
      controller: controller,
      onChanged: (text) {
        switch (i) {
          case 0:
            {
              url = text;
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
        helperText: help,
        prefixIcon: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          textField(
            label: AppLocalizations.of(context).trans('url'),
            controller: urlController,
            icon: Icon(Icons.language),
            i: 0,
          ),
          SizedBox(height: 10),
          textField(
            label: AppLocalizations.of(context).trans('username'),
            controller: usernameController,
            icon: Icon(Icons.perm_identity),
            i: 1,
          ),
          SizedBox(height: 10),
          textField(
            label: AppLocalizations.of(context).trans('password'),
            controller: passwordController,
            icon: Icon(Icons.lock_open),
            font: "mono",
            i: 2,
            help: AppLocalizations.of(context).trans('leave_blank'),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton.icon(
                onPressed: () async {
                  await Antenna().generatePassword().then((onValue) {
                    password = onValue;
                    setState(() {
                      passwordController.text = onValue;
                    });
                  });
                },
                icon: Icon(Icons.shuffle),
                label: Text(AppLocalizations.of(context).trans('gen_pw')),
              ),
              RaisedButton.icon(
                onPressed: () async {
                  await Antenna().update(widget.credential.id, url, username, password);
                  Navigator.of(context).pop();
                  setState(() {});
                },
                icon: Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                label: Text(
                  AppLocalizations.of(context).trans('save'),
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
