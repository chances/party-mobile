// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exception.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiException _$ApiExceptionFromJson(Map<String, dynamic> json) {
  return ApiException(json['message'] as String)
    ..serverErrors = (json['serverErrors'] as List)
        ?.map((e) =>
            e == null ? null : PartyError.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$ApiExceptionToJson(ApiException instance) =>
    <String, dynamic>{
      'message': instance.message,
      'serverErrors': instance.serverErrors
    };
