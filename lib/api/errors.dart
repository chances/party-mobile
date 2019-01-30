import 'package:json_annotation/json_annotation.dart';

part 'errors.g.dart';

@JsonSerializable(createToJson: false)
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
}

@JsonSerializable(createToJson: false)
class ErrorMetadata extends Object {
  ErrorMetadata();
  static ErrorMetadata fromJson(Map<String, dynamic> json) =>
      _$ErrorMetadataFromJson(json);

  String cause;

  String details;
}
