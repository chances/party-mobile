import 'package:owl/annotation/json.dart';

@JsonClass()
class PartyError {
  @JsonField(key: 'status')
  int code;

  String title;

  @JsonField(key: 'detail')
  String message;

  @JsonField(key: 'meta')
  ErrorMetadata metadata;
}

@JsonClass()
class ErrorMetadata {
  String cause;

  String details;
}
