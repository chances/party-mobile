// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SpotifyToken _$SpotifyTokenFromJson(Map<String, dynamic> json) {
  return SpotifyToken()
    ..accessToken = json['access_token'] as String
    ..tokenExpiry = json['token_expiry'] as String;
}

Map<String, dynamic> _$SpotifyTokenToJson(SpotifyToken instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'token_expiry': instance.tokenExpiry
    };
