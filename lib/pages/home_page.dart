import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'about_page.dart';
import 'login_page.dart';
import 'detail_page.dart';
import 'package:Passwall/utils/gatekeeper.dart';
import 'package:Passwall/utils/objects.dart';
import 'package:Passwall/widgets/create_fab_widget.dart';
import 'package:Passwall/widgets/detail_widget.dart';
import 'package:Passwall/widgets/list_widget.dart';
import 'package:flutter/material.dart';
import 'package:Passwall/utils/antenna.dart';
import 'package:Passwall/localization/localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  Login _selectedValue;
  bool _isLargeScreen,
      _isSafe = true;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        setState(() {});
        (_isSafe)
            ? _try2login()
            : GateKeeper().authenticator(context).then((success) {
          if (success) {
            _isSafe = success;
            _try2login();
          }
        });
        break;
      case AppLifecycleState.paused:
        Timer(Duration(minutes: 5), () {
          _isSafe = false;
        });
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }

  _try2login() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String server = preferences.getString("server") ?? "";
    String username = preferences.getString("username") ?? "";
    String password = preferences.getString("password") ?? "";
    Antenna().login(username, password, server).then((success) {
      if (!success) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new LoginPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery
        .of(context)
        .size
        .shortestSide > 600) {
      _isLargeScreen = true;
    } else {
      _isLargeScreen = false;
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("PassWall", style: TextStyle(fontFamily: "serif", fontWeight: FontWeight.w900)),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => [
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
                    preferences.remove("password");
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new LoginPage()));
                  }
              }
            },
          )
        ],
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            child: ListWidget(onItemSelected: (value) {
              if (_isLargeScreen) {
                setState(() {
                  _selectedValue = value;
                });
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(value))).then((value) {
                  setState(() {});
                });
              }
            }),
          ),
          _isLargeScreen ? Expanded(child: DetailWidget(_selectedValue)) : Container(),
        ],
      ),
      floatingActionButton: FABWidget(_hasAdded),
    );
  }

  _hasAdded(data) {
    if (data) {
      setState(() {});
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).trans('success_added'))));
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).trans('swr'))));
    }
  }
}
