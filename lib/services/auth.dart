import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:party/constants.dart';

class Auth {
  static Future<AuthorizationTokenResponse> withSpotify() async {
    try {
      var appAuth = FlutterAppAuth();
      return await appAuth.authorizeAndExchangeCode(AuthorizationTokenRequest(
        'party_api',
        'tunage://auth/callback',
        clientSecret: 'tunage_secrets',
        serviceConfiguration: AuthorizationServiceConfiguration(
          'https://accounts.spotify.com/authorize',
          'https://accounts.spotify.com/api/token',
        ),
        scopes: [
          'user-read-private',
          'user-library-read',
          'user-library-modify',
          'playlist-read-private',
          'playlist-read-collaborative',
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
