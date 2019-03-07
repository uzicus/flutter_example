
import 'package:flutter/material.dart';
import 'package:flutter_app/localization.dart';
import 'package:flutter_app/ui/contacts/contacts_screen.dart';
import 'package:flutter_app/ui/projects/projects_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(Localization.of(context).mainScreenTitle),
      ),
      body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RaisedButton(
                  child: Text(Localization.of(context).contactsTitle),
                  onPressed: () {
                    _openContacts(context);
                  },
                ),
                RaisedButton(
                  child: Text(Localization.of(context).projectsTitle),
                  onPressed: () {
                    _openProjects(context);
                  },
                ),
              ],
            ),
          )
      ),
    );
  }

  void _openContacts(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactsScreen()
        )
    );
  }

  void _openProjects(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProjectsScreen()
        )
    );
  }
}