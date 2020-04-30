import 'package:Passwall/pages/home_page.dart';
import 'package:Passwall/utils/antenna.dart';
import 'package:Passwall/localization/localization_delegate.dart';
import 'package:Passwall/pages/login_page.dart';
import 'package:Passwall/utils/gatekeeper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.deepOrangeAccent,
            textTheme: ButtonTextTheme.accent,
          ),
        ),
        home: Gate(),
        supportedLocales: [const Locale('tr'), const Locale('en')],
        localizationsDelegates: [
          AppLocalizationDelegate(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        localeResolutionCallback: (Locale locale, Iterable<Locale> supportedLocales) {
          if (locale == null) {
            debugPrint("*language locale is null!!!");
            return supportedLocales.first;
          }
          for (Locale supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode || supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }

          return supportedLocales.first;
        });
  }
}

class Gate extends StatefulWidget {
  @override
  _GateState createState() => _GateState();
}

class _GateState extends State<Gate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          icon: Icon(
            Icons.fingerprint,
            size: 48,
          ),
          onPressed: _entrance,
        ),
      ),
    );
  }

  _entrance() {
    GateKeeper().authenticator(context).then(
          (success) =>
      {
        if (success) {_try2login()}
      },
    );
  }

  _try2login() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String server = preferences.getString("server") ?? "";
    String username = preferences.getString("username") ?? "";
    String password = preferences.getString("password") ?? "";
    Antenna()
        .login(username, password, server)
        .then((success) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => (success) ? new HomePage() : new LoginPage())));
  }
}
