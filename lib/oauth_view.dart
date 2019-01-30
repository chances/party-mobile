import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:party/constants.dart';

class OAuthView {
  final _channel = const MethodChannel(Constants.mainChannel);
  final FlutterWebviewPlugin _webView;
  final String _loginUrl;
  final String _finishUrl;
  Future _onFinished;
  bool _finished = false;
  bool _closed = false;

  OAuthView(String loginUrl, String finishUrl)
      :
        _loginUrl = loginUrl,
        _finishUrl = finishUrl,
        _webView = new FlutterWebviewPlugin() {
    _onFinished = _webView.onUrlChanged
        .firstWhere((url) => url == _finishUrl)
        .then((_) {
          _finished = true;
          _closed = true;
          this.close();
        });
    _webView.onDestroy.listen((_) => _closed = true);
  }

  bool get isFinished => _finished;
  bool get isCancelled => _closed && !_finished;
  bool get isClosed => _closed;

  Future get onFinished => _onFinished;
  Future get onClosed {
    return Future.any([
      _onFinished,
      _webView.onDestroy.first,
    ]);
  }

  Stream<String> get onUrlChanged => _webView.onUrlChanged;

  void start() {
    _webView.launch(_loginUrl);
  }

  Future close() {
    return _webView.close();
  }

  Future<List<Cookie>> getCookies(String url) {
    return _channel.invokeMethod("getCookies", {
      'url': url
    }).then((result) {
      if (result == null) {
        return <Cookie>[];
      }

      return (result as String).split(';').map((cookie) {
        return new Cookie.fromSetCookieValue(cookie);
      }).toList();
    });
  }
}
