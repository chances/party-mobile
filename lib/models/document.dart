import 'package:json_annotation/json_annotation.dart';
import 'package:party/api/errors.dart';
import 'package:party/models/resource.dart';

part 'document.g.dart';

@JsonSerializable(createToJson: false)
class Document extends Object {
  Document();
  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);

  Resource data;
}

@JsonSerializable(createToJson: false)
class ErrorDocument extends Object {
  ErrorDocument();
  factory ErrorDocument.fromJson(Map<String, dynamic> json) =>
      _$ErrorDocumentFromJson(json);

  List<PartyError> errors;
}
