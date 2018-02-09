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
}
