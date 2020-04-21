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
      appBar: AppBar(title: Text("About")),
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            ListTile(
              title: Text("About This App"),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Developed with Flutter as part of the PassWall organization. The codes of this open source project are on GitHub."),
                  Link(child: Text("Passwall Home Page", style: TextStyle(color: Colors.blue)), url: "https://passwall.io"),
                  Link(child: Text("GitHub Repository", style: TextStyle(color: Colors.blue)), url: "https://github.com/pass-wall/passwall-mobile"),
                ],
              ),
            ),
            ListTile(
              title: Text("Dependencies"),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Link(child: Text("Logos provided by Clearbit", style: TextStyle(color: Colors.blue)), url: "https://clearbit.com/logo"),
                  Text(
                      "http, shared_preferences, esys_flutter_share, path_provider, file_picker, link, flutter_launcher_name, flutter_launcher_icons"),
                ],
              ),
            ),
            ListTile(
              title: Text("Version"),
              subtitle: Text("0.3.0", style: TextStyle(fontFamily: "mono")),
            ),
          ],
        ),
      ),
    );
  }
}
