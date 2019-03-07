
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/localization_strings.dart';

class Localization {

  final Locale _locale;

  Localization(this._locale);

  static Localization of(BuildContext context) {
    return Localizations.of<Localization>(context, Localization);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    "en" : en,
    "ru" : ru
  };

  _getValue(String key) => _localizedValues[_locale.languageCode][key];

  String get appTitle => _getValue(AppTitle);
  String get mainScreenTitle => _getValue(MainScreenTitle);
  String get contactsTitle => _getValue(ContactsTitle);
  String get contactsEmptyTitle => _getValue(ContactsEmptyTitle);
  String get projectsTitle => _getValue(ProjectsTitle);
  String get projectsEmptyTitle => _getValue(ProjectsEmptyTitle);
}

class LocalizationDelegate extends LocalizationsDelegate<Localization> {

  @override
  bool isSupported(Locale locale) {
    return Localization._localizedValues.containsKey(locale.languageCode);
  }

  @override
  Future<Localization> load(Locale locale) {
    return SynchronousFuture<Localization>(Localization(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<Localization> old) => false;

}