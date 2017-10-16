import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:spotify/spotify_io.dart';

import 'package:party/models/interop/set_access_token_state.dart';
import 'package:party/models/party.dart';
import 'package:party/models/spotify.dart';

final app = new AppContext();

class AppContext {
  Spotify get spotify => Spotify.getInstance();
  final router = new Router();

  User user;
  Party party;
  var playlists = <PlaylistSimple>[];

  bool get hasParty => party != null;

  AppContext() {
    spotify.onLogout = (BuildContext context, bool wasAutomatic) {
      if (wasAutomatic) {
        logout(context);
      }
    };
  }

  void login(BuildContext context, SetAccessTokenStateMessage setToken) {
    app.spotify.setToken(setToken.accessToken, setToken.expiresAt);

    app.spotify.client(context).users.me().then((user) {
      this.user = user;

      final route = app.router.matchRoute(
        context, '/party',
        transitionType: TransitionType.fadeIn,
      ).route;
      Navigator.pushReplacement(context, route);
    });
  }

  void logout(BuildContext context) {
    if (spotify.isLoggedIn) {
      spotify.logout(context);
    }

    new Future.value(Navigator.of(context).canPop())
        .then((canPop) => _navigateToLoginPage(context, canPop))
        .then((_) {
      user = null;
      party = null;
      playlists.clear();
    });
  }

  void logoutIfNecessary(BuildContext context) {
    if (!app.spotify.isLoggedIn) {
      logout(context);
    }
  }

  Future<bool> _navigateToLoginPage(BuildContext context, bool popRoutes) {
    if (popRoutes) {
      Navigator.popUntil(context, (Route route) => route.isFirst);
    }

    final route = app.router.matchRoute(
        context, '/login',
        transitionType: TransitionType.inFromBottom
    ).route;
    Navigator.pushReplacement(context, route);
    // ignore: invalid_use_of_protected_member
    return route.didPush();
  }
}
