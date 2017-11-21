import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:party/api/auth.dart';
import 'package:party/api/party.dart';
import 'package:party/constants.dart';

typedef Future<String> Request(Uri path);

class ApiBase {
  final Cookie _session;
  static Uri _baseUri = Uri.parse(Constants.partyApi);
  http.Client _client;

  Auth _auth;
  Party _party;

  ApiBase(this._session) {
    _client = new http.Client();

    _auth = new Auth(this);
    _party = new Party(this);
  }

  Uri get baseUri => _baseUri;
  Auth get auth => _auth;
  Party get party => _party;

  Future<String> get(Uri path) async {
    var response = await _client.get(path, headers: {
      'Cookie': _session.toString(),
    });

    return UTF8.decode(response.bodyBytes);
  }

  Future<String> post(Uri path, dynamic body) async {
    var response = await _client.post(path, headers: {
      'Cookie': _session.toString(),
    }, body: body);

    return UTF8.decode(response.bodyBytes);
  }
}
