import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:party/app_context.dart';
import 'package:party/constants.dart';
import 'package:party/models/interop/message.dart';
import 'package:party/models/interop/set_access_token_state.dart';
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
  static const platform = const MethodChannel('com.chancesnow.party/spotify');
  BasicMessageChannel<Message> channel;

  var _loggingIn = false;

  _LoginPageState() {
    channel =  new BasicMessageChannel<Message>(Constants.spotifyMessageChannel, Message.codec);
    channel.setMessageHandler((Message m) {
      if (SetAccessTokenStateMessage.instanceOf(m)) {
        SetAccessTokenStateMessage setToken = new SetAccessTokenStateMessage(m);

        app.login(context, setToken);
      }
    });
  }

  Future<Null> _login() async {
    try {
      setState(() {
        _loggingIn = true;
      });
      await platform.invokeMethod('login');
    } on PlatformException catch (e) {
      app.spotify.logout(context);

      setState(() {
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
                  'images/party_logo.png',
                  width: 300.0,
                ),
              ),
            ],
          ),
          new Center(
              child: _loggingIn
                  ? Constants.loading
                  : new PrimaryButton('Login with Spotify', onPressed: _login)
          ),
          new Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Constants.footer,
          ),
        ],
      ),
    );
  }
}
