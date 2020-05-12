import 'package:party/api/errors.dart';

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
}
