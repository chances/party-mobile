import 'dart:async';

import 'package:party/models/party.dart' as models;
import 'package:party/api/base.dart';
import 'package:party/api/endpoint.dart';
import 'package:party/models/party.json.g.dart';

class Party extends Endpoint {
  Party(ApiBase api) : super(api);

  Future<models.Party> get() async {
    try {
      var json = await api.get(route('/party'));
      return PartyMapper.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  Future<Null> end() async {
    await api.post(route('/party/stop'));
  }
}
