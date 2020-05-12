// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) {
  return Session()
    ..accessToken = json['access_token'] as String
    ..refreshToken = json['refresh_token'] as String
    ..tokenExpiry = json['token_expiry'] == null
        ? null
        : DateTime.parse(json['token_expiry'] as String)
    ..idToken = json['id_token'] as String
    ..additionalParameters =
        json['additional_parameters'] as Map<String, dynamic>;
}

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'token_expiry': instance.tokenExpiry?.toIso8601String(),
      'id_token': instance.idToken,
      'additional_parameters': instance.additionalParameters
    };
