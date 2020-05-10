import 'package:party/constants/environment.dart';

const AUTH_ZERO_DOMAIN = 'AUTH_ZERO_DOMAIN';
const AUTH_ZERO_CLIENT_ID = 'AUTH_ZERO_CLIENT_ID';
const _authDomain =
    String.fromEnvironment(AUTH_ZERO_DOMAIN, defaultValue: null);
const _authClientId =
    String.fromEnvironment(AUTH_ZERO_CLIENT_ID, defaultValue: null);

class AuthConstants {
  static var _env = EnvironmentConstants();
  static String _domain =
      _env.fromEnvironmentOrDie(AUTH_ZERO_DOMAIN, _authDomain);
  static String _clientId =
      _env.fromEnvironmentOrDie(AUTH_ZERO_CLIENT_ID, _authClientId);

  String domain = _domain;
  String clientId = _clientId;
  String tokenEndpoint = '$_domain/oauth/token';

  String authorizeWithSpotifyCallback = 'tunage://auth/callback';
  String authorizeWithSpotifyEndpoint =
      '$_authDomain/authorize/?connection=Spotify-Tunage';
}
