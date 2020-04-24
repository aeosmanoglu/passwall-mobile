import 'package:flutter/material.dart';
import 'package:Passwall/localization/localization.dart';
import 'package:Passwall/utils/antenna.dart';

class FABWidget extends StatefulWidget {
  @override
  _FABWidgetState createState() => _FABWidgetState();
}

class _FABWidgetState extends State<FABWidget> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: dialog,
    );
  }

  void dialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String title = "";
        String username = "";
        String password = "";
        return AlertDialog(
          title: Text(AppLocalizations.of(context).trans('create_new')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).trans('url'),
                  hintText: "http://passwall.io",
                ),
                onChanged: (text) {
                  title = text;
                },
              ),
              TextField(
                autocorrect: false,
                decoration: InputDecoration(labelText: AppLocalizations.of(context).trans('username')),
                onChanged: (text) {
                  username = text;
                },
              ),
              TextField(
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).trans('password'),
                  helperText: AppLocalizations.of(context).trans('leave_blank'),
                ),
                onChanged: (text) {
                  password = text;
                },
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(AppLocalizations.of(context).trans('cancel')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              child: Text(AppLocalizations.of(context).trans('save')),
              onPressed: () async {
                if (title == null || title == "") {
                  title = AppLocalizations.of(context).trans('no_title');
                }
                await Antenna().create(title: title, username: username, password: password);
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }
}
