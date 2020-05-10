import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Environment { Production, Staging, Development }

class EnvironmentConstants {
  Map<String, String> get variables => DotEnv().env;
  Environment get mode => variables.containsKey('MODE') &&
          Environment.values
              .map((e) => e.toString())
              .contains(variables['MODE'])
      ? Environment.values
          .firstWhere((element) => element.toString() == variables['MODE'])
      : bool.fromEnvironment('dart.vm.product')
          ? Environment.Production
          : Environment.Development;
  bool get isProduction => mode == Environment.Production;

  String fromEnvironmentOrDie(String key, String value) {
    if (value == null || value.length == 0) {
      var message = StringBuffer();
      message.write("Expected compile-time environment declaration '$key'");
      message.writeln(", i.e. --dart-define=$key=<value>");
      if (isProduction) {
        throw new StateError(message.toString());
      } else {
        throw new AssertionError(message.toString());
      }
    }
    return value;
  }
}
