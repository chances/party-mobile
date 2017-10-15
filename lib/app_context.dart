import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:party/models/interop/set_access_token_state.dart';

import 'package:party/models/spotify.dart';
import 'package:spotify/spotify_io.dart';

final app = new AppContext();

class AppContext {
  Spotify get spotify => Spotify.getInstance();
  final router = new Router();

  User user;
  var playlists = <PlaylistSimple>[];

  void login(BuildContext context, SetAccessTokenStateMessage setToken) {
    app.spotify.setToken(setToken.accessToken, setToken.expiresAt);

    app.spotify.client.users.me().then((user) {
      this.user = user;

      final route = app.router.matchRoute(
        context, '/playlists',
        transitionType: TransitionType.fadeIn,
      ).route;
      Navigator.pushReplacement(context, route);
    });
  }

  void logout(BuildContext context) {
    spotify.logout();

    _navigateToLoginPage(context)
        .asStream().asBroadcastStream().listen((_) {
      user = null;
      playlists = <PlaylistSimple>[];
    });
  }

  void logoutIfNecessary(BuildContext context) {
    if (!app.spotify.isLoggedIn || app.spotify.isTokenExpired) {
      logout(context);
    }
  }

  Future _navigateToLoginPage(BuildContext context) {
    Navigator.popUntil(context, (Route route) => route.isFirst);

    final route = app.router.matchRoute(
        context, '/login',
        transitionType: TransitionType.inFromBottom
    ).route;
    Navigator.pushReplacement(context, route);
    // ignore: invalid_use_of_protected_member
    return route.didPush();
  }
}
