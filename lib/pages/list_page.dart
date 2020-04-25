import 'dart:io';
import 'package:Passwall/pages/about_page.dart';
import 'package:Passwall/utils/antenna.dart';
import 'package:Passwall/localization/localization.dart';
import 'package:Passwall/pages/login_page.dart';
import 'package:Passwall/widgets/create_fab_widget.dart';
import 'package:Passwall/widgets/list_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PassWall", style: TextStyle(fontFamily: "serif", fontWeight: FontWeight.w900)),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) =>
            [
              PopupMenuItem(value: 0, child: Text(AppLocalizations.of(context).trans('import'))),
              PopupMenuItem(value: 1, child: Text(AppLocalizations.of(context).trans('export'))),
              PopupMenuItem(value: 2, child: Text(AppLocalizations.of(context).trans('about'))),
              PopupMenuItem(value: 3, child: Text(AppLocalizations.of(context).trans('logout'), style: TextStyle(color: Colors.red))),
            ],
            onSelected: (value) async {
              switch (value) {
                case 0:
                  {
                    File file;
                    file = await FilePicker.getFile(type: FileType.custom, allowedExtensions: ['csv']);
                    await Antenna().import(file);
                    setState(() {});
                    _scaffoldKey.currentState.showSnackBar(
                        SnackBar(content: Text(AppLocalizations.of(context).trans('success_imported')), duration: Duration(milliseconds: 500),)
                    );
                    break;
                  }
                case 1:
                  {
                    Antenna().export();
                    break;
                  }
                case 2:
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => new AboutPage()));
                    break;
                  }
                case 3:
                  {
                    print("Loging out");
                    SharedPreferences preferences = await SharedPreferences.getInstance();
                    preferences.remove("token");
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new LoginPage()));
                  }
              }
            },
          )
        ],
      ),
      body: Scaffold(
        key: _scaffoldKey,
        body: ListWidget(),
      ),
      floatingActionButton: FABWidget(hasAdded),
    );
  }

  hasAdded(data) {
    if (data) {
      setState(() {});
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).trans('success_added')), duration: Duration(milliseconds: 700),)
      );
    } else {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).trans('swr')), duration: Duration(milliseconds: 700),)
      );
    }
  }

}