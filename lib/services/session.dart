import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:jose/jose.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:party/constants.dart';
import 'package:party/models.dart';

part 'session.g.dart';

@JsonSerializable()
class Session {
  @JsonKey(ignore: true)
  JsonWebSignature _accessTokenJws;
  @JsonKey(ignore: true)
  JsonWebSignature _idTokenJws;

  @JsonKey(name: 'is_valid')
  bool _isVerified = false;

  Session();
  static Session fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);

  static Session fromTokenResponse(TokenResponse tokenResponse) {
    var session = Session();
    session.accessToken = tokenResponse.accessToken;
    session.refreshToken = tokenResponse.refreshToken;
    session.tokenExpiry = tokenResponse.accessTokenExpirationDateTime;
    session.idToken = tokenResponse.idToken;
    session.additionalParameters = tokenResponse.tokenAdditionalParameters;
    return session;
  }

  @JsonKey(name: 'access_token')
  String accessToken;

  @JsonKey(name: 'refresh_token')
  String refreshToken;

  @JsonKey(name: 'token_expiry')
  DateTime tokenExpiry;

  @JsonKey(name: 'id_token')
  String idToken;

  @JsonKey(name: 'additional_parameters')
  Map<String, dynamic> additionalParameters;

  @JsonKey(ignore: true)
  bool get isExpired => !tokenExpiry.isAfter(DateTime.now().toUtc());

  @JsonKey(ignore: true)
  bool get isVerified => _isVerified;

  Map<String, dynamic> toJson() => _$SessionToJson(this);

  /// Convert this Session's claims to a [SpotifyToken], assuming this [Session]'s tokens have
  /// been validated
  SpotifyToken toSpotifyToken() {
    if (_idTokenJws == null || !isVerified) return null;

    var payload = _idTokenJws.unverifiedPayload.jsonContent;
    var accessToken = payload[Constants.auth.claims.spotifyAccessToken];
    var refreshToken = payload[Constants.auth.claims.spotifyRefreshToken];
    var expiresIn = payload[Constants.auth.claims.spotifyExpiresIn];

    if (!(expiresIn is int)) return null;

    return SpotifyToken()
      ..accessToken = accessToken
      ..refreshToken = refreshToken
      ..tokenExpiry = DateTime.now()
          .toUtc()
          .add(Duration(seconds: (expiresIn as int) - 5))
          .toIso8601String();
  }

  Future<bool> verifyTokens() async {
    var verified = false;

    _accessTokenJws = JsonWebSignature.fromCompactSerialization(accessToken);
    _idTokenJws = JsonWebSignature.fromCompactSerialization(idToken);

    // Validate the Access token
    var payload = _accessTokenJws.unverifiedPayload.jsonContent;
    // What's the jws.unverifiedPayload.protectedHeader.`kid` claim? https://stackoverflow.com/q/43867440/1363247

    var commonPropsValid =
        _isTokenCommonPropsValid(Constants.auth.domain, payload);
    var audienceValid = false;
    if (payload['aud'] is List) {
      audienceValid =
          (payload['aud'] as List<dynamic>).contains(Constants.auth.audience);
    } else if (payload['aud'] is String) {
      audienceValid =
          (payload['aud'] as String).compareTo(Constants.auth.audience) == 0;
    }
    var roles = payload['${Constants.auth.audience}/roles'];
    var rolesValid = roles != null &&
        roles is List &&
        roles.contains('host') &&
        roles.contains('guest');
    var azpValid =
        (payload['azp'] as String).compareTo(Constants.auth.clientId) == 0;
    var scopes = payload['scope'] is String ? (payload['scope'] as String) : '';
    var scopesList = scopes.split(' ');
    var scopeValid = scopesList.length > 0 &&
        scopesList.contains('host') &&
        scopesList.contains('guest');

    verified = commonPropsValid &&
        rolesValid &&
        audienceValid &&
        azpValid &&
        scopeValid;

    if (!verified) {
      _accessTokenJws = null;
      _idTokenJws = null;
      return false;
    }

    // Validate the ID token
    payload = _idTokenJws.unverifiedPayload.jsonContent;

    commonPropsValid = _isTokenCommonPropsValid(Constants.auth.domain, payload);
    roles = payload['${Constants.auth.audience}/roles'];
    rolesValid = roles != null &&
        roles is List &&
        roles.contains('host') &&
        roles.contains('guest');
    var spotifyScopes = payload[Constants.auth.claims.spotifyScope];
    scopeValid = spotifyScopes != null &&
        spotifyScopes is String &&
        spotifyScopes.compareTo(
                'playlist-read-private playlist-read-collaborative user-library-read user-library-modify user-read-private') ==
            0;

    verified &= rolesValid && commonPropsValid && scopeValid;

    // TODO Verify the token with a key store?
    // var keyStore = new JsonWebKeyStore()..addKey(jws.commonHeader.jsonWebKey);
    // var verified = await jws.verify(keyStore);

    if (!verified) {
      _accessTokenJws = null;
      _idTokenJws = null;
      return false;
    }

    return _isVerified = verified;
  }

  bool _isTokenCommonPropsValid(String issuer, dynamic payload) {
    var issuedAt = payload['iat'] as int;
    var nowInSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    var durationSinceIssuance = Duration(seconds: nowInSeconds - issuedAt);
    var issuedAtValid = issuedAt is int && durationSinceIssuance.inSeconds < 6;
    var expiry = payload['exp'] as int;
    var durationUntilExpiration = Duration(seconds: expiry - nowInSeconds);
    var expiryValid = !durationUntilExpiration.isNegative;
    var issuerObserved = payload['iss'] as String;
    var issuerValid = false;
    if (issuerObserved.endsWith('/') && !issuer.endsWith('/')) {
      issuerValid = issuerObserved.compareTo('$issuer/') == 0;
    } else if (issuer.endsWith('/')) {
      issuerValid = '$issuerObserved/'.compareTo(issuer) == 0;
    }

    return issuerValid && issuedAtValid && expiryValid;
  }
}
