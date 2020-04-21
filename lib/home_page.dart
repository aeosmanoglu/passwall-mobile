import 'dart:io';

import 'package:Passwall/about.dart';
import 'package:Passwall/antenna.dart';
import 'package:Passwall/detail_page.dart';
import 'package:Passwall/login_page.dart';
import 'package:Passwall/objects.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Credential>> future;
  String searchQuery = "";

  @override
  void initState() {
    future = Antenna().getCredentials();
    super.initState();
  }


  Future<bool> _showConfirmationDialog(context) {
    return showDialog(context: context, barrierDismissible: false, builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Are you sure to delete this credential?'),
        actions: <Widget>[
          FlatButton.icon(onPressed: () {
            Navigator.pop(context, true);
          }, icon: Icon(Icons.check), label: Text('Yes')),
          FlatButton.icon(onPressed: () {
            Navigator.pop(context, false);
          }, icon: Icon(Icons.close), label: Text('No')),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    future = searchQuery == "" ? Antenna().getCredentials() : Antenna().search(searchQuery);
    return Scaffold(
      appBar: AppBar(
        title: Text("PassWall"),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) =>
            [
              PopupMenuItem(value: 0, child: Text("Import")),
              PopupMenuItem(value: 1, child: Text("Export")),
              PopupMenuItem(value: 2, child: Text("About")),
              PopupMenuItem(value: 3, child: Text("Log Out", style: TextStyle(color: Colors.red))),
            ],
            onSelected: (value) async {
              switch (value) {
                case 0:
                  {
                    File file;
                    file = await FilePicker.getFile(type: FileType.custom, allowedExtensions: ['csv']);
                    await Antenna().import(file);
                    setState(() {});
                    //TODO: Add a snackbar
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
      body: RefreshIndicator(
        onRefresh: refresh,
        child: Column(
          children: <Widget>[
            TextField(
              autocorrect: false,
              decoration: InputDecoration(prefixIcon: Icon(Icons.search)),
              onChanged: (text) {
                setState(() {
                  searchQuery = text;
                });
              },
            ),
            FutureBuilder(
              future: future,
              builder: (BuildContext context, AsyncSnapshot<List<Credential>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return Text(snapshot.error);
                    } else if (snapshot.data.length == 0 || snapshot.data == null) {
                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.inbox, size: 50, color: Colors.black26),
                            Text("There is no data", style: Theme
                                .of(context)
                                .textTheme
                                .title),
                          ],
                        ),
                      );
                    } else {
                      return Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 80),
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: AlignmentDirectional.centerEnd,
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 28, 0),
                                  child: Icon(Icons.delete_sweep, color: Colors.white),
                                ),
                              ),
                              onDismissed: (direction) async {
                                await Antenna().deleteCredential(snapshot.data[index].id);
                              },
                              confirmDismiss: (DismissDirection direction) async {
                                switch (direction) {
                                  case DismissDirection.endToStart:
                                    return await _showConfirmationDialog(context);
                                    break;
                                  default:
                                }
                                return false;
                              },
                              child: Card(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailPage(snapshot.data[index])));
                                  },
                                  title: Text(snapshot.data[index].url),
                                  subtitle: Text(snapshot.data[index].username),
                                  leading: Stack(
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          snapshot.data[index].url[0].toUpperCase(),
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .display1,
                                        ),
                                        width: 40,
                                        height: 40,
                                        alignment: Alignment(0, 0),
                                      ),
                                      ClipOval(
                                        child: Image.network(
                                          "http://logo.clearbit.com/${snapshot.data[index].url}?size=80",
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      //IconButton(icon: Icon(Icons.person), onPressed: () {
                                      //  Clipboard.setData(ClipboardData(text: snapshot.data[index].username));
                                      //  print("Username copied to Clipboard: " + snapshot.data[index].username);
                                      //  Scaffold.of(context).showSnackBar(SnackBar(content: Text("Username copied to clipboard.")));
                                      //}),
                                      //IconButton(
                                      //    icon: Icon(Icons.content_copy),
                                      //    onPressed: () {
                                      //      Clipboard.setData(ClipboardData(text: snapshot.data[index].password));
                                      //      print("Password copied to Clipboard: " + snapshot.data[index].password);
                                      //      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Password copied to clipboard.")));
                                      //    }),
                                      //IconButton(
                                      //    icon: Icon(Icons.share),
                                      //    onPressed: () {
                                      //      Credential i = snapshot.data[index];
                                      //      Share.share(
                                      //        "URL: ${i.url}, Username: ${i.username}, Password: ${i.password}",
                                      //        subject: "Sensetive data from PassWall",
                                      //      );
                                      //    }),
                                      // Action menu suspended for now
                                      PopupMenuButton(
                                        icon: Icon(Icons.more_vert),
                                        itemBuilder: (BuildContext context) =>
                                        [
                                          PopupMenuItem(value: 0, child: Text("Copy Username")),
                                          PopupMenuItem(value: 1, child: Text("Copy Password")),
                                          PopupMenuItem(value: 2, child: Text("Share")),
                                        ],
                                        onSelected: (value) {
                                          switch (value) {
                                            case 0:
                                              {
                                                Clipboard.setData(ClipboardData(text: snapshot.data[index].username));
                                                print("Username copied to Clipboard: " + snapshot.data[index].username);
                                                Scaffold.of(context).showSnackBar(SnackBar(content: Text("Username copied to clipboard.")));
                                                break;
                                              }
                                            case 1:
                                              {
                                                Clipboard.setData(ClipboardData(text: snapshot.data[index].password));
                                                print("Password copied to Clipboard: " + snapshot.data[index].password);
                                                Scaffold.of(context).showSnackBar(SnackBar(content: Text("Password copied to clipboard.")));
                                                break;
                                              }
                                            case 2:
                                              {
                                                Credential i = snapshot.data[index];
                                                Share.text(
                                                  "Sensitive data from PassWall",
                                                  "Sensitive data from PassWall\nURL: ${i.url}\nUsername: ${i.username}\nPassword: ${i.password}",
                                                  "text/plain",
                                                );
                                              }
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: createNew,
      ),
    );
  }

  void createNew() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String title = "";
        String username = "";
        String password = "";
        return AlertDialog(
          title: Text("Create new credential"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                autocorrect: false,
                decoration: InputDecoration(labelText: "Title", hintText: "http://passwall.io"),
                onChanged: (text) {
                  title = text;
                },
              ),
              TextField(
                autocorrect: false,
                decoration: InputDecoration(labelText: "Username"),
                onChanged: (text) {
                  username = text;
                },
              ),
              TextField(
                autocorrect: false,
                decoration: InputDecoration(labelText: "Password", helperText: "Leave blank for a random password"),
                onChanged: (text) {
                  password = text;
                },
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("CANCEL"),
              textColor: Colors.red,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("SAVE"),
              onPressed: () async {
                if (title == null || title == "") {
                  title = "NoTitle";
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

  Future<void> refresh() async {
    await Future.delayed(Duration(milliseconds: 400));
    setState(() {});
  }
}
