// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'errors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartyError _$PartyErrorFromJson(Map<String, dynamic> json) {
  return PartyError()
    ..code = json['status'] as int
    ..title = json['title'] as String
    ..message = json['detail'] as String
    ..metadata = json['meta'] == null
        ? null
        : ErrorMetadata.fromJson(json['meta'] as Map<String, dynamic>);
}

ErrorMetadata _$ErrorMetadataFromJson(Map<String, dynamic> json) {
  return ErrorMetadata()
    ..cause = json['cause'] as String
    ..details = json['details'] as String;
}
