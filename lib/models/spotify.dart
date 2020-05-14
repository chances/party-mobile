import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:party/constants.dart';
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

  bool get isLoggedIn =>
      _accessToken != null && _tokenExpiry != null && !isTokenExpired;
  String get accessToken => _accessToken;
  DateTime get tokenExpiry => _tokenExpiry;
  int get expiresIn =>
      tokenExpiry.difference(new DateTime.now().toUtc()).inSeconds;
  bool get isTokenExpired => _tokenExpiry.isBefore(new DateTime.now().toUtc());

  SpotifyApi client(BuildContext context) {
    if (!isLoggedIn) {
      _client = null;
      _loggedOutAutomatically = true;
      logout(context);
      return null;
    }
    if (_client == null) {
      _client = new SpotifyApi(
          SpotifyApiCredentials.implicitGrant(accessToken, expiresIn));
    }
    return _client;
  }

  void setToken(String accessToken, DateTime tokenExpiry) {
    _accessToken = accessToken;
    _tokenExpiry = tokenExpiry;

    if (isLoggedIn && _client != null) {
      // TODO: Add update token call to spotify-dart?
      _client = new SpotifyApi(
          SpotifyApiCredentials.implicitGrant(accessToken, expiresIn));
    }

    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(Constants.prefs.spotifyAccessToken, _accessToken);
      prefs.setString(
          Constants.prefs.spotifyTokenExpiry, _tokenExpiry?.toIso8601String());
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
        final accessToken = prefs.getString(Constants.prefs.spotifyAccessToken);
        final tokenExpiryString =
            prefs.getString(Constants.prefs.spotifyTokenExpiry);

        if (accessToken != null &&
            accessToken.isNotEmpty &&
            tokenExpiryString != null &&
            tokenExpiryString.isNotEmpty) {
          _accessToken = accessToken;
          _tokenExpiry = DateTime.parse(tokenExpiryString);

          if (isTokenExpired) {
            setToken(null, null);
          }
        }
      } catch (e) {
        setToken(null, null);
        // TODO: Send this to Sentry?
      }

      return isLoggedIn;
    });
  }
}
