import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:party/app_context.dart';
import 'package:party/constants.dart';
import 'package:party/models/interop/message.dart';
import 'package:party/services/auth.dart';
import 'package:party/services/exceptions.dart';
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
  static const platform = const MethodChannel('com.chancesnow.tunage');
  BasicMessageChannel<Message> channel;

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
      setState(() => _loggingIn = true);

      if (app.isLoggedIn) {
        await app.login(context);

        return;
      }

      await Future.delayed(new Duration(milliseconds: 300));

      var session = await Auth.withSpotify();
      var loggedIn = session != null;

      // Auth page didn't login (e.g. user pressed back), reset login page
      if (!loggedIn) {
        setState(() => _loggingIn = false);
        return;
      }

      await Future.delayed(new Duration(milliseconds: 500));

      // TODO: Send breadcrumb to Sentry
      await app.login(context, session);
    } on Exception catch (ex) {
      app.spotify.logout(context);

      setState(() => _loggingIn = false);

      String message;

      if (ex is PlatformException) {
        message = ex.message;
        // TODO: Log error details (i.e. JSON details) to Sentry
      }
      if (ex is NestedException) {
        message = '${ex.message}\n\n${ex.innerException.toString()}';
      }

      Scaffold.of(context).showSnackBar(new SnackBar(
        duration: Duration(seconds: 5),
        content: new Text('Could not login.'),
        action: SnackBarAction(
          label: 'More Info',
          onPressed: () => showErrorDialog(
            context,
            'Could not Login',
            ex,
            message,
          ),
        ),
      ));
    }
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
                  child: _loggingIn
                      ? Constants.loading
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
