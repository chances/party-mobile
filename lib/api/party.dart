import 'dart:async';
import 'dart:convert';

import 'package:party/models.dart' as models;
import 'package:party/api/base.dart';
import 'package:party/api/endpoint.dart';
import 'package:party/api/exception.dart';

class Party extends Endpoint {
  Party(ApiBase api) : super(api);

  Future<models.Party> get() async {
    try {
      var response = await api.get(route('/party'));
      var document = models.Document.fromJson(response);
      return document.data.getData(models.Party.fromJson);
    } on ApiException catch (ex) {
      throw ex;
    } catch (ex) {
      // TODO: All the APIs should catch like this and submit to Sentry the error
      return null;
    }
  }

  Future<models.Party> start(String hostName, String playlistId) async {
    try {
      var bodyRaw = {'host': hostName, 'playlist_id': playlistId};
      var body = json.encode({'data': bodyRaw});
      var response = await api.post(route('/party/start'), body: body);
      var document = models.Document.fromJson(response);
      return document.data.getData(models.Party.fromJson);
    } catch (ex) {
      // TODO: All the APIs should catch like this and submit to Sentry the error
      return null;
    }
  }

  Future<Null> end() {
    return api.post(route('/party/end'));
  }
}
