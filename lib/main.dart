import 'package:flutter/material.dart';
import 'package:flutter_app/localization.dart';
import 'package:flutter_app/ui/main_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        LocalizationDelegate()
      ],
      supportedLocales: [
        Locale('en', ''),
        Locale('ru', 'RU')
      ],
      title: "Flutter Demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}
