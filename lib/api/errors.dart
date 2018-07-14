import 'package:json_annotation/json_annotation.dart';

part 'errors.g.dart';

@JsonSerializable()
class PartyError extends Object with _$PartyErrorSerializerMixin {
  PartyError();
  factory PartyError.fromJson(Map<String, dynamic> json) => _$PartyErrorFromJson(json);

  @JsonKey(name: 'status')
  int code;

  String title;

  @JsonKey(name: 'detail')
  String message;

  @JsonKey(name: 'meta')
  ErrorMetadata metadata;
}

@JsonSerializable()
class ErrorMetadata extends Object with _$ErrorMetadataSerializerMixin {
  ErrorMetadata();
  factory ErrorMetadata.fromJson(Map<String, dynamic> json) => _$ErrorMetadataFromJson(json);

  String cause;

  String details;
}
