import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';

import 'package:party/models/spotify.dart';
import 'package:spotify/spotify_io.dart';

final app = new AppContext();

class AppContext {
  Spotify get spotify => Spotify.getInstance();
  final router = new Router();

  var playlists = <PlaylistSimple>[];

  void logout(BuildContext context) {
    spotify.logout();

    _navigateToLoginPage(context);
  }

  void logoutIfNecessary(BuildContext context) {
    if (!app.spotify.loggedIn || app.spotify.isTokenExpired) {
      logout(context);
    }
  }

  void _navigateToLoginPage(BuildContext context) {
    Navigator.popUntil(context, (Route route) => route.isFirst);

    final route = app.router.matchRoute(
        context, '/login',
        transitionType: TransitionType.inFromBottom
    ).route;
    Navigator.pushReplacement(context, route);
  }
}
