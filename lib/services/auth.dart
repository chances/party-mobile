import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:party/constants.dart';
import 'package:party/services/exceptions.dart';
import 'package:party/services/session.dart';

class Auth {
  static Future<Session> withSpotify() async {
    try {
      var appAuth = FlutterAppAuth();
      print(Constants.auth.authorizeWithSpotifyEndpoint);
      var result =
          await appAuth.authorizeAndExchangeCode(AuthorizationTokenRequest(
        Constants.auth.clientId,
        Constants.auth.authorizeCallback,
        serviceConfiguration: AuthorizationServiceConfiguration(
          Constants.auth.authorizeWithSpotifyEndpoint,
          Constants.auth.tokenEndpoint,
        ),
        scopes: [
          'openid',
          'name',
          'host',
          'guest',
        ],
        additionalParameters: {},
      ));

      var session = Session.fromTokenResponse(result);
      var isSessionValid = await session.verifyTokens();
      if (!isSessionValid) {
        throw NestedException("Exchanged tokens are invalid");
      }
      return session;
    } on Exception catch (ex) {
      if (ex is NestedException) {
        throw NestedException("Could not login with Spotify", ex);
      }

      // Reset to logged out state when user cancels, i.e. back button, etc.
      if (ex.toString().contains('User cancelled flow'))
        return Future.value(null);

      throw ex;
    }
  }
}
