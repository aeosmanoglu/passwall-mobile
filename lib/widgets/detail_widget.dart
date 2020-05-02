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
  TextEditingController _urlController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _url, _username, _password;

  @override
  Widget build(BuildContext context) {
    _url = widget.credential?.url ?? "";
    _username = widget.credential?.username ?? "";
    _password = widget.credential?.password ?? "";
    _urlController.text = _url;
    _usernameController.text = _username;
    _passwordController.text = _password;
    return (widget.credential == null)
        ? Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Image.asset("assets/select.png", width: 200),
        SizedBox(height: 10),
        Text(AppLocalizations.of(context).trans('select'), style: Theme
            .of(context)
            .textTheme
            .title)
      ],
    )
        : ListView(
      padding: EdgeInsets.all(40),
      children: <Widget>[
        _textField(
          label: AppLocalizations.of(context).trans('url'),
          controller: _urlController,
          icon: Icon(Icons.language),
          i: 0,
        ),
        SizedBox(height: 10),
        _textField(
          label: AppLocalizations.of(context).trans('username'),
          controller: _usernameController,
          icon: Icon(Icons.perm_identity),
          i: 1,
        ),
        SizedBox(height: 10),
        _textField(
          label: AppLocalizations.of(context).trans('password'),
          controller: _passwordController,
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
                  _password = onValue;
                  setState(() {
                    _passwordController.text = onValue;
                  });
                });
              },
              icon: Icon(Icons.shuffle),
              label: Text(AppLocalizations.of(context).trans('gen_pw')),
            ),
            RaisedButton.icon(
              onPressed: () async {
                await Antenna().update(widget.credential.id, _url, _username, _password);
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

  Widget _textField({
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
              _url = text;
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
        helperText: help,
        prefixIcon: icon,
      ),
    );
  }
}
