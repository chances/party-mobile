import 'package:party/constants/environment.dart';

const AUTH_ZERO_DOMAIN = 'AUTH_ZERO_DOMAIN';
const AUTH_ZERO_AUDIENCE = 'AUTH_ZERO_AUDIENCE';
const AUTH_ZERO_CLIENT_ID = 'AUTH_ZERO_CLIENT_ID';
const _authDomain =
    String.fromEnvironment(AUTH_ZERO_DOMAIN, defaultValue: null);
const _authAudience =
    String.fromEnvironment(AUTH_ZERO_AUDIENCE, defaultValue: null);
const _authClientId =
    String.fromEnvironment(AUTH_ZERO_CLIENT_ID, defaultValue: null);

class AuthConstants {
  static var _env = EnvironmentConstants();
  static String _domain =
      _env.fromEnvironmentOrDie(AUTH_ZERO_DOMAIN, _authDomain);
  static String _audience =
      _env.fromEnvironmentOrDie(AUTH_ZERO_DOMAIN, _authAudience);
  static String _clientId =
      _env.fromEnvironmentOrDie(AUTH_ZERO_CLIENT_ID, _authClientId);

  String get domain => _domain;
  String get audience => _audience;
  String get clientId => _clientId;
  String get tokenEndpoint => '$_domain/oauth/token';
  String get authorizeCallback => 'tunage://auth/callback';

  static var _claims = ClaimsConstants();
  ClaimsConstants get claims => _claims;

  String get authorizeWithSpotifyEndpoint =>
      '$_domain/authorize?audience=$_audience&connection=Spotify-Tunage';
}

class ClaimsConstants {
  String get namespace => 'https://apps.chancesnow.me';
  String get spotifyAccessToken => '$namespace/auth/spotify/access_token';
  String get spotifyRefreshToken => '$namespace/auth/spotify/refresh_token';
  String get spotifyExpiresIn => '$namespace/auth/spotify/expires_in';
  String get spotifyScope => '$namespace/auth/spotify/scope';
}
