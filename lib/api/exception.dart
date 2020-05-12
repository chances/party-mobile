import 'package:json_annotation/json_annotation.dart';
import 'package:party/api/errors.dart';

part 'exception.g.dart';

@JsonSerializable()
class ApiException implements Exception {
  String message;
  List<PartyError> serverErrors;

  ApiException(this.message) {
    print(message);
  }

  ApiException.fromPartyErrors(List<PartyError> errors) {
    message = errors.first.message;
    serverErrors = errors;
    print(message);
  }

  String toString() {
    var serverErrorMessages =
        serverErrors?.map((e) => '${e.title}: ${e.message}') ?? [];
    var errors = serverErrorMessages.join('\n');
    return serverErrorMessages.length > 0 ? '$message\n\n$errors' : message;
  }

  Map<String, dynamic> toJson() => _$ApiExceptionToJson(this);
}
