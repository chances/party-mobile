// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotifyToken _$SpotifyTokenFromJson(Map<String, dynamic> json) {
  return new SpotifyToken()
    ..accessToken = json['access_token'] as String
    ..tokenExpiry = json['token_expiry'] as String;
}

abstract class _$SpotifyTokenSerializerMixin {
  String get accessToken;
  String get tokenExpiry;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'access_token': accessToken,
        'token_expiry': tokenExpiry
      };
}
