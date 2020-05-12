import 'dart:async';
import 'dart:convert';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:party/api/base.dart';
import 'package:party/api/exception.dart';
import 'package:party/constants.dart';
import 'package:party/services/exceptions.dart';
import 'package:party/services/session.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify_io.dart';

import 'package:party/models/party.dart';
import 'package:party/models/spotify.dart';

export 'assets.dart';

final app = new AppContext();

class AppContext {
  Session _session;
  ApiBase _api;

  Spotify get spotify => Spotify.getInstance();
  final router = new Router();

  User user;
  Party party;
  var playlists = <PlaylistSimple>[];

  AppContext() {
    SharedPreferences.getInstance().then((prefs) {
      var session = prefs.getString(Constants.prefs.sessionKey);

      if (session != null && session.isNotEmpty) {
        _session = Session.fromJson(json.decode(session));

        _api = new ApiBase(_session.accessToken);
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

  Future login(BuildContext context, [Session session]) async {
    if (session == null && _session == null) {
      throw new ArgumentError.notNull('session');
    } else if (session != null) {
      _session = session;

      var prefs = await SharedPreferences.getInstance();
      var wasSessionSaved = await prefs.setString(
          Constants.prefs.sessionKey, json.encode(_session.toJson()));
      if (!wasSessionSaved) {
        throw new NestedException('Could not save session state');
      }
    }

    _api = new ApiBase(_session.accessToken);

    try {
      await _fetchSpotifyTokenAndParty().catchError((error) => throw error);
    } on Exception catch (ex) {
      await logout(context);

      throw NestedException(
        'Unable to exchange authorization with Tunage API',
        ex,
      );
    }

    // Fetch the current Host's Spotify user profile
    // TODO: Get this from Auth0 land, via a call to <tenant_domain>/userinfo?
    this.user = await app.spotify.client(context).users.me();
    // TODO: Handle Spotify API errors

    final route = app.router
        .matchRoute(
          context,
          '/party',
          transitionType: TransitionType.fadeIn,
        )
        .route;
    Navigator.pushReplacement(context, route);
  }

  Future logout(BuildContext context) async {
    if (spotify.isLoggedIn) {
      spotify.logout(context);
    }

    var canPop = Navigator.of(context).canPop();
    var didPop = await _navigateToLoginPage(context, canPop);

    _api = null;
    _session = null;
    user = null;
    party = null;
    playlists.clear();

    var prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  void logoutIfNecessary(BuildContext context) {
    if (!app.spotify.isLoggedIn) {
      logout(context);
    }
  }

  Future<Party> endParty(BuildContext context) async {
    try {
      await api.party.end();
    } on ApiException catch (e) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => new AlertDialog(
          title: new Text('Party Error'),
          content: new Text(e.message),
        ),
      );

      return party;
    }

    // TODO: Anything else to do to end a party?

    return null;
  }

  /// In parallel, get the Host's Spotify access token and the current party, if any
  Future<void> _fetchSpotifyTokenAndParty() async {
    var getToken = Future.value(_session.toSpotifyToken())
        .then((token) =>
            token != null ? Future.value(token) : _api.auth.getToken())
        .then(
          (token) => app.spotify.setToken(
            token.accessToken,
            DateTime.parse(token.tokenExpiry),
          ),
        );
    var getParty = app.api.party.get().then((party) => this.party = party);
    await Future.wait([getToken, getParty]);
  }

  /// Navigate to the root Login route, resolves to [true] when the route did change.
  Future<bool> _navigateToLoginPage(BuildContext context, bool popRoutes) {
    if (popRoutes) {
      Navigator.popUntil(context, (Route route) => route.isFirst);
    }

    final route = app.router
        .matchRoute(context, '/login',
            transitionType: TransitionType.inFromBottom)
        .route;
    Navigator.pushReplacement(context, route);
    // ignore: invalid_use_of_protected_member
    return route.didPush().then((_) => true);
  }
}
