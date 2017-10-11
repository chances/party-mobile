import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';
import 'widgets/RoundedButton.dart';
import 'interop/Message.dart';
import 'interop/SetLoginStateMessage.dart';
import 'interop/SetAccessTokenStateMessage.dart';

void main() {
  runApp(new PartyApp());
}

class PartyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Party',
      theme: new ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Constants.colorPrimary,
        accentColor: Constants.colorAccent,
        backgroundColor: Constants.colorPrimary,

        textTheme: Constants.typography.white,
      ),
      home: new LoginPage(title: 'Party'),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const platform = const MethodChannel('com.chancesnow.party/spotify');
  BasicMessageChannel<Message> channel;

  String _accessToken;
  DateTime _tokenExpiry;

  _LoginPageState() {
    channel =  new BasicMessageChannel<Message>(Constants.spotifyMessageChannel, Message.codec);
    channel.setMessageHandler((Message m) {
      if (SetLoginStateMessage.instanceOf(m)) {
        SetLoginStateMessage setLogin = new SetLoginStateMessage(m);

        // TODO: Set login state in some app context?
      }
      if (SetAccessTokenStateMessage.instanceOf(m)) {
        SetAccessTokenStateMessage setToken = new SetAccessTokenStateMessage(m);

        // TODO: Set auth token in some app context?

        setState(() {
          _accessToken = setToken.accessToken;
          _tokenExpiry = setToken.expiresAt;
        });
      }
    });
  }

  Future<Null> _login() async {
    try {
      await platform.invokeMethod('login');
    } on PlatformException catch (e) {
      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(
          'Failed to login: ${e.message}.'
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double statusBarHeight = mediaQueryData.padding.top;
    final double screenHeight = mediaQueryData.size.height;
    final double screenHeightMinusAppBarHeight = screenHeight - statusBarHeight;

    return new Scaffold(
//      appBar: new AppBar(
//        title: new Text("Party"),
//      ),
      backgroundColor: Constants.statusBarColor,
      body: new Stack(
        children: [
          new Positioned(
            top: statusBarHeight,
            right: 0.0,
            left: 0.0,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Padding(
                  padding: new EdgeInsets.only(top: 16.0),
                  child: new Image.asset(
                    "images/party_logo.png",
                    width: 300.0,
                  ),
                ),
              ],
            ),
          ),
          new Positioned(
              top: statusBarHeight,
              right: 0.0,
              left: 0.0,
              height: screenHeightMinusAppBarHeight,
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new RoundedButton(
                        color: Constants.colorAccent,
                        height: 48.0,
                        padding: new EdgeInsets.only(left: 36.0, right: 36.0),
                        onPressed: _login,
                        child: new Text(
                            'Login with Spotify',
                            style: Constants.typography.white.button)
                    ),
                  ]
              )
          ),
          Constants.footer
        ],
      ),
    );
  }
}
