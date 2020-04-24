import 'package:Passwall/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:link/link.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).trans('about'))),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            ListTile(
              title: Text(AppLocalizations.of(context).trans('about_this_app')),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(AppLocalizations.of(context).trans('about_this_app_')),
                  Link(child: Text("passwall.io", style: TextStyle(color: Colors.blue)), url: "https://passwall.io"),
                  Link(child: Text("GitHub Repository", style: TextStyle(color: Colors.blue)), url: "https://github.com/pass-wall/passwall-mobile"),
                ],
              ),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).trans('dependencies')),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Link(child: Text("Logos provided by Clearbit", style: TextStyle(color: Colors.blue)), url: "https://clearbit.com/logo"),
                  Text("http, "
                      "shared_preferences, "
                      "esys_flutter_share, "
                      "path_provider, "
                      "file_picker, "
                      "link"),
                ],
              ),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).trans('version')),
              subtitle: Text("0.5.0", style: TextStyle(fontFamily: "mono")),
            ),
          ],
        ),
      ),
    );
  }
}
