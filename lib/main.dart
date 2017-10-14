import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'package:party/app_context.dart';
import 'package:party/constants.dart';
import 'package:party/theme.dart';
import 'package:party/views/login_page.dart';
import 'package:party/views/playlists_page.dart';

void main() {
  // TODO: Add an app init '/' route, load stored config (SharedPrefs)
  app.router.define("/", handler: new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
      app.spotify.loadFromPrefsAndValidateSession().then((loggedIn) {
        final path = loggedIn ? '/playlists' : '/login';

        final route = app.router.matchRoute(
            context, path,
            transitionType: TransitionType.fadeIn
        ).route;
        Navigator.pushReplacement(context, route);
      });

      return new Container(color: Constants.colorPrimaryDark);
    }
  ));
  app.router.define("/login", handler: LoginPage.handler);
  app.router.define("/playlists", handler: PlaylistsPage.handler);
  app.router.printTree();

  runApp(new PartyApp());
}

class PartyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Party',
      theme: partyTheme,
//      initialRoute: '/login',
      onGenerateRoute: app.router.generator,
    );
  }
}
