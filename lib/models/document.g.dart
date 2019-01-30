// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Document _$DocumentFromJson(Map<String, dynamic> json) {
  return Document()
    ..data = json['data'] == null
        ? null
        : Resource.fromJson(json['data'] as Map<String, dynamic>);
}

ErrorDocument _$ErrorDocumentFromJson(Map<String, dynamic> json) {
  return ErrorDocument()
    ..errors = (json['errors'] as List)
        ?.map((e) =>
            e == null ? null : PartyError.fromJson(e as Map<String, dynamic>))
        ?.toList();
}
