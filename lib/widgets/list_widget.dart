import 'package:flutter/services.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:Passwall/utils/antenna.dart';
import 'package:Passwall/localization/localization.dart';
import 'package:Passwall/utils/objects.dart';
import 'package:flutter/material.dart';

typedef Null ItemSelectedCallback(Login value);

class ListWidget extends StatefulWidget {
  final ItemSelectedCallback onItemSelected;

  const ListWidget({this.onItemSelected});

  @override
  _ListWidgetState createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  String _searchQuery = "";
  Future<List<Login>> _future;

  @override
  void initState() {
    _future = Antenna().getAllLogins();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _future = _searchQuery == "" ? Antenna().getAllLogins() : Antenna().search(_searchQuery);
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: _future,
              builder: (BuildContext context, AsyncSnapshot<List<Login>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[CircularProgressIndicator()],
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else if (snapshot.data.length == 0 || snapshot.data == null) {
                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset("assets/no_data.png", width: 200),
                            SizedBox(height: 10),
                            Text(AppLocalizations.of(context).trans('no_data'), style: Theme
                                .of(context)
                                .textTheme
                                .headline6)
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
                                bool response = await Antenna().deleteLogin(snapshot.data[index].id);
                                if (response) {
                                  setState(() {});
                                }
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
                                    widget.onItemSelected(snapshot.data[index]);
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
                                              .headline4,
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
                                  trailing: PopupMenuButton(
                                    icon: Icon(Icons.more_vert),
                                    itemBuilder: (BuildContext context) =>
                                    [
                                      PopupMenuItem(value: 0, child: Text(AppLocalizations.of(context).trans('copy_username'))),
                                      PopupMenuItem(value: 1, child: Text(AppLocalizations.of(context).trans('copy_pw'))),
                                      PopupMenuItem(value: 2, child: Text(AppLocalizations.of(context).trans('share'))),
                                    ],
                                    onSelected: (value) {
                                      switch (value) {
                                        case 0:
                                          {
                                            Clipboard.setData(ClipboardData(text: snapshot.data[index].username));
                                            print("Username copied to Clipboard: " + snapshot.data[index].username);
                                            Scaffold.of(context)
                                                .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).trans('copy_username_'))));
                                            break;
                                          }
                                        case 1:
                                          {
                                            Clipboard.setData(ClipboardData(text: snapshot.data[index].password));
                                            print("Password copied to Clipboard: " + snapshot.data[index].password);
                                            Scaffold.of(context)
                                                .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context).trans('copy_pw_'))));
                                            break;
                                          }
                                        case 2:
                                          {
                                            Login i = snapshot.data[index];
                                            Share.text(
                                              AppLocalizations.of(context).trans('sensitive'),
                                              AppLocalizations.of(context).trans('sensitive') +
                                                  "\nURL: ${i.url}\nUsername: ${i.username}\nPassword: ${i.password}",
                                              "text/plain",
                                            );
                                          }
                                      }
                                    },
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
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: TextField(
                autocorrect: false,
                decoration: InputDecoration(prefixIcon: Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(40))),
                onChanged: (text) {
                  setState(() {
                    _searchQuery = text;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    await Future.delayed(Duration(milliseconds: 400));
    setState(() {});
  }

  Future<bool> _showConfirmationDialog(context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).trans('delete_confirmation')),
          actions: <Widget>[
            FlatButton.icon(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                icon: Icon(Icons.check),
                label: Text(AppLocalizations.of(context).trans('yes'))),
            FlatButton.icon(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                icon: Icon(Icons.close),
                label: Text(AppLocalizations.of(context).trans('no'))),
          ],
        );
      },
    );
  }
}
