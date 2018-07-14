import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:party/app_context.dart';
import 'package:party/constants.dart';
import 'package:party/models/interop/message.dart';
import 'package:party/oauth_view.dart';
import 'package:party/views/widgets/primary_button.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  static final handler = new Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        return new LoginPage();
      }
  );

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const platform = const MethodChannel('com.chancesnow.party');
  BasicMessageChannel<Message> channel;

  var _attemptingLogin = false;
  var _loggingIn = false;

  _LoginPageState() {
    channel =  new BasicMessageChannel<Message>(Constants.spotifyMessageChannel, Message.codec);
    channel.setMessageHandler((Message m) {
      // TODO: Use the spotify message channel for player messages
    });
  }

  Future<Null> _login() async {
    try {
      setState(() {
        _attemptingLogin = true;
      });

      if (app.isLoggedIn) {
        await app.login(context);

        setState(() {
          _attemptingLogin = false;
          _loggingIn = true;
        });

        return;
      }

      var partyAuth = new OAuthView(
        '${Constants.partyApi}/auth/mobile',
        '${Constants.partyApi}/auth/finished',
      );
      partyAuth.start();
      await partyAuth.onClosed;
      if (partyAuth.isCancelled) {
        // Auth was cancelled purposefully or by error
        setState(() {
          _attemptingLogin = false;
        });

        // TODO: Detect failed logins

        return;
      }

      var cookies = await partyAuth.getCookies(Constants.partyApi);
      try {
        var sessionCookie = cookies.firstWhere(
                (cookie) => cookie.name == "cpSESSION"
        );

        setState(() {
          _attemptingLogin = false;
          _loggingIn = true;
        });

        await app.login(context, sessionCookie);
      } catch(e) {
        // TODO: Show error dialog: Could not login
        // TODO: Send error to sentry: Could not read session cookie
      }
    } on PlatformException catch (e) {
      app.spotify.logout(context);

      setState(() {
        _attemptingLogin = false;
        _loggingIn = false;
      });

      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(
          'Failed to login: ${e.message}.'
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: [
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Padding(
                padding: new EdgeInsets.only(top: 16.0),
                child: new Image.asset(
                  Assets.img_party_logo,
                  width: 300.0,
                ),
              ),
            ],
          ),
          new Center(
              child: _attemptingLogin || _loggingIn
                  ? _attemptingLogin ? null : Constants.loading
                  : new PrimaryButton('Login with Spotify', onPressed: _login)
          ),
          new Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Constants.footer(context),
          ),
        ],
      ),
    );
  }
}
