import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify_io.dart';

typedef LogoutCallback(BuildContext context, bool wasAutomatic);

class Spotify {
  static final Spotify _instance = new Spotify._createInstance();
  Spotify._createInstance();

  static Spotify getInstance() => Spotify._instance;

  LogoutCallback onLogout;

  String _accessToken;
  DateTime _tokenExpiry;
  SpotifyApi _client;
  bool _loggedOutAutomatically = false;

  bool get isLoggedIn => _accessToken != null &&
      _tokenExpiry != null && !isTokenExpired;
  String get accessToken => _accessToken;
  DateTime get tokenExpiry => _tokenExpiry;
  int get expiresIn => tokenExpiry.difference(new DateTime.now()).inSeconds;
  bool get isTokenExpired => _tokenExpiry.isBefore(new DateTime.now());

  SpotifyApi client(BuildContext context) {
    if (!isLoggedIn) {
      _client = null;
      _loggedOutAutomatically = true;
      logout(context);
      return null;
    }
    if (_client == null) {
      _client = new SpotifyApi(SpotifyApiCredentials.implicitGrant(
          accessToken, expiresIn
      ));
    }
    return _client;
  }

  void setToken(String accessToken, DateTime tokenExpiry) {
    _accessToken = accessToken;
    _tokenExpiry = tokenExpiry;

    if (_client != null) {
      // TODO: Add update token call to spotify-dart?
      _client = new SpotifyApi(SpotifyApiCredentials.implicitGrant(
          accessToken, expiresIn
      ));
    }

    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('SPOTIFY_ACCESS_TOKEN', _accessToken);
      prefs.setString('SPOTIFY_TOKEN_EXPIRY', _tokenExpiry?.toIso8601String());

      return prefs.commit();
    });
  }

  void logout(BuildContext context) {
    setToken(null, null);
    if (onLogout != null) {
      onLogout(context, _loggedOutAutomatically);
    }
    _loggedOutAutomatically = false;
  }

  Future<bool> loadAndValidateSession() {
    return SharedPreferences.getInstance().then((prefs) {
      try {
        final accessToken = prefs.getString('SPOTIFY_ACCESS_TOKEN');
        final tokenExpiryString = prefs.getString('SPOTIFY_TOKEN_EXPIRY');

        if (accessToken != null && accessToken.isNotEmpty &&
          tokenExpiryString != null && tokenExpiryString.isNotEmpty) {
          _accessToken = accessToken;
          _tokenExpiry = DateTime.parse(tokenExpiryString);

          if (isTokenExpired) {
            setToken(null, null);
          }
        }
      } catch (e) {
        setToken(null, null);
      }

      return isLoggedIn;
    });
  }
}
