import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:party/app_context.dart';
import 'package:party/constants.dart';
import 'package:party/models/interop/message.dart';
import 'package:party/views/auth_page.dart';
import 'package:party/views/widgets/primary_button.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  static final handler = new Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new LoginPage();
  });

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const platform = const MethodChannel('com.chancesnow.party');
  BasicMessageChannel<Message> channel;

  var _attemptingLogin = false;
  var _loggingIn = false;

  _LoginPageState() {
    channel = new BasicMessageChannel<Message>(
        Constants.spotifyMessageChannel, Message.codec);
    channel.setMessageHandler((Message m) {
      // TODO: Use the spotify message channel for player messages
    });
  }

  Future<Null> _login(BuildContext context) async {
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

      var loggedIn = await Navigator.of(context)
          .push(new MaterialPageRoute<bool>(builder: (BuildContext context) {
        return AuthPage.handler.handlerFunc(context, null);
      }));

      // Auth page didn't login (e.g. user pressed back), reset login page
      if (loggedIn == null || !loggedIn) {
        setState(() {
          _attemptingLogin = false;
          _loggingIn = false;
        });
        return;
      }

      setState(() {
        _attemptingLogin = false;
        _loggingIn = true;
      });

      // await Future.delayed(new Duration(milliseconds: 500));

      var cookies =
          await AuthPage.getCookies('${Constants.partyApi}/auth/finished');
      try {
        var sessionCookie =
            cookies.firstWhere((cookie) => cookie.name == "cpSESSION");

        await app.login(context, sessionCookie);
      } catch (ex) {
        // TODO: Send error to sentry: Could not read session cookie

        throw Exception('Unable to retrieve session cookie.');
      }
    } on Exception catch (ex) {
      app.spotify.logout(context);

      setState(() {
        _attemptingLogin = false;
        _loggingIn = false;
      });

      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text('Could not login.'),
        action: SnackBarAction(
          label: 'More Info',
          onPressed: () => _showLoginErrorDialog(context, ex.toString()),
        ),
      ));
    }
  }

  Future<Null> _showLoginErrorDialog(BuildContext context, String message,
      [Exception ex]) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Could not Login'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(message),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ex != null ? Text(ex.toString()) : null,
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Submit Feedback'),
                onPressed: () {
                  Navigator.of(context).pop();
                  // TODO: Sentry feedback form, mailto: link, or something?
                },
              ),
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.img_tunage_icon,
                    width: 50.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      'Tunage',
                      style: theme.textTheme.headline,
                    ),
                  )
                ],
              ),
            ),
            Builder(
              builder: (context) => Center(
                  child: _attemptingLogin || _loggingIn
                      ? _attemptingLogin ? null : Constants.loading
                      : PrimaryButton('Login with Spotify',
                          onPressed: () => _login(context))),
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Constants.footer(context),
            ),
          ],
        ),
      ),
    );
  }
}
