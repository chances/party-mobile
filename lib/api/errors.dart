import 'package:json_annotation/json_annotation.dart';

part 'errors.g.dart';

@JsonSerializable()
class PartyError extends Object {
  PartyError();
  static PartyError fromJson(Map<String, dynamic> json) =>
      _$PartyErrorFromJson(json);

  @JsonKey(name: 'status')
  int code;

  String title;

  @JsonKey(name: 'detail')
  String message;

  @JsonKey(name: 'meta')
  ErrorMetadata metadata;

  Map<String, dynamic> toJson() => _$PartyErrorToJson(this);
}

@JsonSerializable()
class ErrorMetadata extends Object {
  ErrorMetadata();
  static ErrorMetadata fromJson(Map<String, dynamic> json) =>
      _$ErrorMetadataFromJson(json);

  String cause;

  String details;

  Map<String, dynamic> toJson() => _$ErrorMetadataToJson(this);
}
