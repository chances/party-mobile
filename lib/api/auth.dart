import 'dart:async';
import 'dart:convert';

import 'package:party/models/auth.dart' as models;
import 'package:party/api/base.dart';
import 'package:party/api/endpoint.dart';

class Auth extends Endpoint {
  Auth(ApiBase api) : super(api);

  Future<models.SpotifyToken> getToken() async {
    var response = await api.get(route('/auth/token'));
    var map = json.decode(response);
    return models.SpotifyToken.fromJson(map);
  }
}
