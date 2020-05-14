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

  Future<Null> _loadSessionOrGotoLogin() async {
    if (!mounted) return;
    // TODO: Preload common images? (spotify footer, party logo, etc.)

    var isLoggedIn = await Future.wait([
      app.loadSession(context),
      Future.delayed(new Duration(milliseconds: 400), () => null),
    ]).then((value) => value.first);

    var didLogout = await app.logout(
      context,
      onlyIfNecessary: true,
      isAppLaunching: true,
    );
    if (didLogout) return;
    assert(isLoggedIn && app.isLoggedIn);

    setState(() {
      _loading = false;
    });

    await Future.delayed(new Duration(milliseconds: 750));

    // If the current Host is still logged in, fade to the Party page
    assert(app.isLoggedIn);
    final route = app.router
        .matchRoute(
          context,
          '/party',
          transitionType: TransitionType.fadeIn,
          transitionDuration: Duration(milliseconds: 500),
        )
        .route;
    Navigator.pushReplacement(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Null>(
        future: _loadSessionOrGotoLogin(),
        builder: (BuildContext context, AsyncSnapshot<Null> snapshot) {
          double logoOpacity = !_loading && app.isLoggedIn ? 0 : 1;

          return AnimatedOpacity(
              opacity: logoOpacity,
              duration: Duration(milliseconds: 300),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
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
                child: Stack(children: [
                  Center(child: Constants.loadingIndicatorWhite),
                ]),
              ));
        });
  }
}
