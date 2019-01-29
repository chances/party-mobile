import 'dart:convert' as Convert;

import 'package:party/api/base.dart';

class Endpoint {
  final ApiBase _api;

  Endpoint(this._api);

  ApiBase get api => _api;

  Uri route(String route, [Map<String, String> params]) {
    if (_api.baseUri.scheme == 'https') {
      return new Uri.https(_api.baseUri.authority, route, params);
    } else {
      return new Uri.http(_api.baseUri.authority, route, params);
    }
  }

  Map attributes(String json) {
    Map data = Convert.json.decode(json)['data'];
    return data['attributes'];
  }
}
