import 'dart:async';
import 'package:flutter/material.dart';
import 'localization.dart';

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {

  const AppLocalizationDelegate();

    @override  
  bool isSupported(Locale locale) => ['tr', 'en'].contains(locale.languageCode);
  
  @override  
  Future<AppLocalizations> load(Locale locale) async {  
    AppLocalizations localizations = new AppLocalizations(locale);  
  await localizations.load();  
  
  print("Load ${locale.languageCode}");  
  
  return localizations;  
  }  
  
  @override  
  bool shouldReload(AppLocalizationDelegate old) => false;  
}