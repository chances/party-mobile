// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'errors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartyError _$PartyErrorFromJson(Map<String, dynamic> json) {
  return new PartyError()
    ..code = json['status'] as int
    ..title = json['title'] as String
    ..message = json['detail'] as String
    ..metadata = json['meta'] == null
        ? null
        : new ErrorMetadata.fromJson(json['meta'] as Map<String, dynamic>);
}

abstract class _$PartyErrorSerializerMixin {
  int get code;
  String get title;
  String get message;
  ErrorMetadata get metadata;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'status': code,
        'title': title,
        'detail': message,
        'meta': metadata
      };
}

ErrorMetadata _$ErrorMetadataFromJson(Map<String, dynamic> json) {
  return new ErrorMetadata()
    ..cause = json['cause'] as String
    ..details = json['details'] as String;
}

abstract class _$ErrorMetadataSerializerMixin {
  String get cause;
  String get details;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'cause': cause, 'details': details};
}
