import 'package:Passwall/utils/antenna.dart';
import 'package:Passwall/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:Passwall/utils/objects.dart';

class DetailWidget extends StatefulWidget {
  final Credential credential;

  DetailWidget(this.credential);

  @override
  _DetailWidgetState createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  TextEditingController urlController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String url, username, password;

  @override
  Widget build(BuildContext context) {
    url = widget.credential?.url ?? "";
    username = widget.credential?.username ?? "";
    password = widget.credential?.password ?? "";
    urlController.text = url;
    usernameController.text = username;
    passwordController.text = password;
    return (widget.credential == null)
        ? Center(
      child: Text("hello"),
    )
        : ListView(
      padding: EdgeInsets.all(40),
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
    );
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
}
