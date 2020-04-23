import 'package:Passwall/antenna.dart';
import 'package:Passwall/home_page.dart';
import 'package:Passwall/localization_delegate.dart';
import 'package:Passwall/login_page.dart';
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
          if (supportedLocale.languageCode == locale.languageCode ||
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }

        return supportedLocales.first;
      }
    );
  }
}

class Gate extends StatefulWidget {
  @override
  _GateState createState() => _GateState();
}

class _GateState extends State<Gate> {
  @override
  Widget build(BuildContext context) {
    // Check the user authorized or not
    getToken().then((token) => router(token));

    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Future<String> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token");
    return token;
  }

  router(String token) {
    Antenna().gateKeeper(token).then((success) {
      if (success) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new HomePage()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new LoginPage()));
      }
    });
  }
}
