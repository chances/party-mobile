import 'dart:async';
import 'dart:convert';

import 'package:party/models/party.dart' as models;
import 'package:party/api/base.dart';
import 'package:party/api/endpoint.dart';

class Party extends Endpoint {
  Party(ApiBase api) : super(api);

  Future<models.Party> get() async {
    try {
      var response = await api.get(route('/party'));
      var map = json.decode(response);
      return models.Party.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<models.Party> start(String hostName, String playlistId) async {
    try {
      var bodyRaw = {
        'host': hostName,
        'playlist_id': playlistId
      };
      var body = json.encode({'data': bodyRaw});
      var response = await api.post(route('/party/start'), body);
      var map = json.decode(response);
      return models.Party.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<Null> end() {
    return api.post(route('/party/end'));
  }
}
