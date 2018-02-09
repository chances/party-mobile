import 'dart:async';
import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:party/api/base.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify_io.dart';

import 'package:party/models/party.dart';
import 'package:party/models/spotify.dart';

final app = new AppContext();

class AppContext {
  Cookie _session;
  ApiBase _api;

  Spotify get spotify => Spotify.getInstance();
  final router = new Router();

  User user;
  Party party;
  var playlists = <PlaylistSimple>[];

  AppContext() {
    SharedPreferences.getInstance().then((prefs) {
      var session = prefs.getString('PARTY_SESSION');

      if (session != null && session.isNotEmpty) {
        _session = new Cookie.fromSetCookieValue(session);

        _api = new ApiBase(_session);
      }
    });

    spotify.onLogout = (BuildContext context, bool wasAutomatic) {
      if (wasAutomatic) {
        logout(context);
      }
    };
  }

  bool get isLoggedIn => _session != null;
  bool get hasParty => party != null;

  ApiBase get api => _api;

  Future login(BuildContext context, [Cookie sessionCookie]) async {
    if (sessionCookie == null && _session == null) {
      throw new ArgumentError.notNull('sessionCookie');
    } else if (sessionCookie != null) {
      _session = sessionCookie;

      var prefs = await SharedPreferences.getInstance();
      prefs.setString('PARTY_SESSION', _session.toString());
      await prefs.commit();
    }

    _api = new ApiBase(_session);

    var token = await _api.auth.getToken();
    app.spotify.setToken(token.accessToken, DateTime.parse(token.tokenExpiry));

    var user = await app.spotify.client(context).users.me();
    this.user = user;
    this.party = await app.api.party.get();

    final route = app.router.matchRoute(
      context, '/party',
      transitionType: TransitionType.fadeIn,
    ).route;
    Navigator.pushReplacement(context, route);
  }

  void logout(BuildContext context) {
    if (spotify.isLoggedIn) {
      spotify.logout(context);
    }

    new Future.value(Navigator.of(context).canPop())
        .then((canPop) => _navigateToLoginPage(context, canPop))
        .then((_) {
      _api = null;
      _session = null;
      user = null;
      party = null;
      playlists.clear();

      return SharedPreferences.getInstance();
    }).then((prefs) {
      return prefs.clear();
    });
  }

  void logoutIfNecessary(BuildContext context) {
    if (!app.spotify.isLoggedIn) {
      logout(context);
    }
  }

  Future<Party> endParty() async {
    await api.party.end();
    // TODO: Handle errors, if failed return existing party?

    // TODO: Anything else to do to end a party?

    return null;
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
