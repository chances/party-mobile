import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'package:party/app_context.dart';
import 'package:party/constants.dart';
import 'package:party/views/widgets/primary_button.dart';

class PartyPage extends StatefulWidget {
  PartyPage({Key key}) : super(key: key);

  static final handler = new Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return new PartyPage();
      }
  );

  @override
  _PartyPageState createState() => new _PartyPageState();
}

class _PartyPageState extends State<PartyPage> {
  bool _loading = true;

  Future<Null> get _loadUser {
    return null;
  }

  void _selectPlaylist() {
    Navigator.of(context).pushNamed('/playlists')
        .then((_) {

    });
  }

  @override
  Widget build(BuildContext context) {
    final actions = [
      Constants.logoutMenu(context)
    ];

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Your Party"),
        actions: actions,
        backgroundColor: Constants.statusBarColor,
        elevation: 4.0,
      ),
      bottomNavigationBar: Constants.footer,
      body: new Center(
          child: new PrimaryButton(
              'Select Playlist', onPressed: _selectPlaylist
          )
      ),
    );
  }
}
