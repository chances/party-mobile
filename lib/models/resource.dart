import 'package:json_annotation/json_annotation.dart';

part 'resource.g.dart';

@JsonSerializable(createToJson: false)
class Resource extends Object {
  Resource();
  factory Resource.fromJson(Map<String, dynamic> json) =>
      _$ResourceFromJson(json);

  String id;
  String type;
  Map<String, dynamic> attributes;

  T getData<T>(T parse(Map<String, dynamic> json)) => parse(attributes);
}
