import 'package:flutter/material.dart';

import 'package:party/constants.dart';
import 'package:party/views/login_page.dart';

void main() {
  runApp(new PartyApp());
}

class PartyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Party',
      theme: new ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Constants.colorPrimary,
        accentColor: Constants.colorAccent,
        backgroundColor: Constants.colorPrimary,

        textTheme: Constants.typography.white,
      ),
      home: new LoginPage(),
    );
  }
}
