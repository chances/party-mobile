import 'dart:async';

import 'package:party/models/auth.dart' as models;
import 'package:party/api/base.dart';
import 'package:party/api/endpoint.dart';
import 'package:party/models/auth.json.g.dart';

class Auth extends Endpoint {
  Auth(ApiBase api) : super(api);

  Future<models.SpotifyToken> getToken() async {
    var json = await api.get(route('/auth/token'));
    return SpotifyTokenMapper.fromJson(json);
  }
}
