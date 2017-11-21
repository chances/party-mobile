import 'package:party/api/base.dart';

class Endpoint {
  final ApiBase _api;

  Endpoint(this._api);

  ApiBase get api => _api;

  Uri route(String route) {
    if (_api.baseUri.scheme == 'https') {
      return new Uri.https(_api.baseUri.authority, route);
    } else {
      return new Uri.http(_api.baseUri.authority, route);
    }
  }
}
