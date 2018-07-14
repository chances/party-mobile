import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:party/api/auth.dart';
import 'package:party/api/errors.dart';
import 'package:party/api/exception.dart';
import 'package:party/api/party.dart';
import 'package:party/api/playback.dart';
import 'package:party/constants.dart';

typedef Future<String> Request(Uri path);

class ApiBase {
  final Cookie _session;
  static Uri _baseUri = Uri.parse(Constants.partyApi);
  http.Client _client;

  Auth _auth;
  Party _party;
  Playback _playback;

  ApiBase(this._session) {
    _client = new http.Client();

    _auth = new Auth(this);
    _party = new Party(this);
    _playback = new Playback(this);
  }

  Uri get baseUri => _baseUri;
  Auth get auth => _auth;
  Party get party => _party;
  Playback get playback => _playback;

  Future<String> get(Uri path) async {
    http.Response response = await _client.get(path, headers: {
      'Cookie': _session.toString(),
    });
    String body = UTF8.decode(response.bodyBytes);
    handleErrors(response, body);

    return body;
  }

  Future<String> post(Uri path, [dynamic body]) async {
    var headers = {
      'Cookie': _session.toString(),
    };
    if (body != null) {
      headers['Content-Type'] = 'application/json';
    }
    var response = await _client.post(path, headers: headers, body: body);
    String responseBody = UTF8.decode(response.bodyBytes);
    handleErrors(response, responseBody);

    return responseBody;
  }

  void handleErrors(http.Response response, String body) {
    if (response.statusCode == 404) {
      PartyError error = new PartyError();
      error.code = response.statusCode;
      error.message = 'Party could not find the resource';
      throw new ApiException.fromPartyErrors([error]);
    } else if (response.statusCode != 200 && response.headers.containsKey('content-type') && response.headers['content-type'].startsWith('application/json')) {
      List<dynamic> errors = JSON.decode(body);
      throw new ApiException.fromPartyErrors(errors.map((json) => PartyError.fromJson(json)));
    } else if (response.statusCode != 200) {
      throw new ApiException('Party received an invalid response from the server');
    }
  }
}
