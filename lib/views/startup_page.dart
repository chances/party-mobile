import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'package:party/app_context.dart';
import 'package:party/constants.dart';
import 'package:spotify/spotify_io.dart' show User;

class StartupPage extends StatefulWidget {
  StartupPage({Key key}) : super(key: key);

  static final handler = new Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return new StartupPage();
      }
  );

  @override
  _StartupPageState createState() => new _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  bool _loading = true;

  Future<Null> get _loadUser {
    return app.spotify.loadFromPrefsAndValidateSession().then((user) {
      app.user = user;
      setState(() {
        _loading = false;
      });

      return new Future.delayed(new Duration(milliseconds: 500), () {});
    }).then((_) {
      final path = app.spotify.loggedIn ? '/playlists' : '/login';
      final transition = app.spotify.loggedIn
          ? TransitionType.native
          : TransitionType.fadeIn;

      final route = app.router.matchRoute(
        context, path,
        transitionType: transition,
      ).route;
      Navigator.pushReplacement(context, route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<Null>(
        future: _loadUser,
        builder: (BuildContext context, AsyncSnapshot<Null> snapshot) {
          return new Stack(children: [
            // TODO: Animate logo from position in launch background
            new AnimatedOpacity(
                opacity: _loading ? 1.0 : 0.0,
                duration: new Duration(milliseconds: 400),
                child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Padding(
                        padding: new EdgeInsets.only(top: 16.0),
                        child: new Image.asset(
                          'images/party_logo.png',
                          width: 300.0,
                        ),
                      ),
                    ]
                )
            ),
            new Center(child: new CircularProgressIndicator(
              valueColor: Constants.loadingColorAnimation,
            ))
          ]);
        }
    );
  }
}
