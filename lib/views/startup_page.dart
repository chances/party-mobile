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
  });

  @override
  _StartupPageState createState() => new _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  bool _loading = true;
  bool _loaded = false;

  Future<Null> _loadUser() async {
    if (_loaded) return;

    var isLoggedIn = await app.spotify.loadAndValidateSession();
    app.user = isLoggedIn ? await app.spotify.client(context).users.me() : null;

    if (app.user != null) {
      app.party = await app.api.party.get();
    }

    setState(() {
      _loading = false;
    });

    // TODO: Preload common images (spotify footer, party logo, etc.)

    _loaded = true;

    await new Future.delayed(new Duration(milliseconds: 400), () {});

    // If the current Host is still logged in jump to the Party page,
    //  otherwise navigate to the login page with a fancy fade
    final path = app.isLoggedIn ? '/party' : '/login';
    final transitionDuration = app.isLoggedIn
        ? new Duration(seconds: 0)
        : new Duration(milliseconds: 750);

    final route = app.router
        .matchRoute(context, path,
            transitionType: TransitionType.fadeIn,
            transitionDuration: transitionDuration)
        .route;
    Navigator.pushReplacement(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<Null>(
        future: _loadUser(),
        builder: (BuildContext context, AsyncSnapshot<Null> snapshot) {
          double logoOpacity = 1.0;
          if (!_loading && app.spotify.isLoggedIn) {
            logoOpacity = 0.0;
          }

          return new AnimatedOpacity(
              opacity: logoOpacity,
              duration: new Duration(milliseconds: 300),
              child: new Container(
                decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Constants.colorBrandGradientBlue,
                        Constants.colorBrandGradientPurple,
                        Constants.colorBrandGradientPurple,
                      ],
                      stops: [
                        0.0,
                        0.9,
                        1.0
                      ]),
                ),
                child: new Stack(children: [
                  new Center(child: Constants.loadingIndicatorWhite)
                ]),
              ));
        });
  }
}
