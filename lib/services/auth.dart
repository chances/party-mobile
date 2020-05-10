import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:party/constants.dart';

class Auth {
  static Future<AuthorizationTokenResponse> withSpotify() async {
    try {
      var appAuth = FlutterAppAuth();
      return await appAuth.authorizeAndExchangeCode(AuthorizationTokenRequest(
        Constants.auth.clientId,
        Constants.auth.authorizeWithSpotifyCallback,
        serviceConfiguration: AuthorizationServiceConfiguration(
          Constants.auth.authorizeWithSpotifyEndpoint,
          Constants.auth.tokenEndpoint,
        ),
        scopes: [
          'openid',
          'name',
        ],
      ));
    } on Exception catch (ex) {
      // Reset to logged out state when user cancels, i.e. back button, etc.
      if (ex.toString().contains('User cancelled flow'))
        return Future.value(null);

      throw ex;
    }
  }
}
