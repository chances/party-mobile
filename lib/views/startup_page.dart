import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'package:party/app_context.dart';
import 'package:party/constants.dart';

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
    return app.spotify.loadAndValidateSession().then(
            (isLoggedIn) {
              return isLoggedIn
                ? app.spotify.client(context).users.me()
                  : null;
            }
    ).then((user) {
      app.user = user;
      setState(() {
        _loading = false;
      });

      return new Future.delayed(new Duration(milliseconds: 400), () {});
    }).then((_) {
      final path = app.spotify.isLoggedIn ? '/party' : '/login';
      final transitionDuration = app.spotify.isLoggedIn
          ? new Duration(seconds: 0)
          : new Duration(milliseconds: 750);

      final route = app.router.matchRoute(
        context, path,
        transitionType: TransitionType.fadeIn,
        transitionDuration: transitionDuration
      ).route;
      Navigator.pushReplacement(context, route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<Null>(
        future: _loadUser,
        builder: (BuildContext context, AsyncSnapshot<Null> snapshot) {
          double logoOpacity = 1.0;
          if (!_loading && app.spotify.isLoggedIn) {
            logoOpacity = 0.0;
          }

          return new AnimatedOpacity(
              opacity: logoOpacity,
              duration: new Duration(milliseconds: 300),
              child: new Stack(children: [
                // TODO: Animate logo from position in launch background
                new Row(
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
                ),
                new Center(child: new CircularProgressIndicator(
                  valueColor: Constants.loadingColorAnimation,
                ))
              ])
          );
        }
    );
  }
}
