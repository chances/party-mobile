import 'dart:async';
import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:party/constants.dart';

// Fix for missing activity context for autofill:
// https://github.com/flutter/flutter/issues/25767#issuecomment-480567263

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => new _AuthPageState();

  static final handler = new Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
    return new AuthPage();
  });

  static Future<List<Cookie>> getCookies(String url) {
    var channel = const MethodChannel(Constants.mainChannel);
    return channel.invokeMethod("getCookies", {'url': url}).then((result) {
      if (result == null) {
        return <Cookie>[];
      }

      return (result as String).split(';').map((cookie) {
        return new Cookie.fromSetCookieValue(cookie);
      }).toList();
    });
  }
}

class _AuthPageState extends State<AuthPage> {
  final String loginUrl = '${Constants.partyApi}/auth/mobile';
  final String finishUrl = '${Constants.partyApi}/auth/finished';

  CookieManager _cookieManager = CookieManager();
  StreamController<String> _urlChanged = StreamController();

  _AuthPageState() {
    _cookieManager.clearCookies();
    _urlChanged.stream
        .firstWhere((url) => url == finishUrl)
        .then((_) => Navigator.of(this.context).pop(true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: WebView(
        initialUrl: loginUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (url) => _urlChanged.add(url),
      ),
    );
  }
}
