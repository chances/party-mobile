import 'dart:async';

import 'package:party/models.dart' as models;
import 'package:party/api/base.dart';
import 'package:party/api/endpoint.dart';

class Auth extends Endpoint {
  Auth(ApiBase api) : super(api);

  Future<models.SpotifyToken> getToken() async {
    var response = await api.get(route('/auth/token'));
    var document = models.Document.fromJson(response);
    return document.data.getData(models.SpotifyToken.fromJson);
  }
}
