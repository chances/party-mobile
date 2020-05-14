import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:party/api/auth.dart';
import 'package:party/api/errors.dart';
import 'package:party/api/exception.dart';
import 'package:party/api/party.dart';
import 'package:party/api/playback.dart';
import 'package:party/api/playlists.dart';
import 'package:party/constants.dart';
import 'package:party/models/document.dart';

typedef Future<String> Request(Uri path);

class ApiBase {
  final Map<String, String> _authorizationHeader;
  static Uri _baseUri = Uri.parse(Constants.partyApi);
  http.Client _client;

  Auth _auth;
  Party _party;
  Playback _playback;
  Playlists _playlists;

  ApiBase(String accessToken)
      : this._authorizationHeader = {
          'Authorization': 'Bearer ${accessToken.toString()}',
        } {
    _client = new http.Client();

    _auth = new Auth(this);
    _party = new Party(this);
    _playback = new Playback(this);
    _playlists = new Playlists(this);
  }

  Uri get baseUri => _baseUri;
  Auth get auth => _auth;
  Party get party => _party;
  Playback get playback => _playback;
  Playlists get playlists => _playlists;

  Future<dynamic> get(Uri path, {bool rawStringResponse = false}) async {
    http.Response response =
        await _client.get(path, headers: _authorizationHeader);
    String body = utf8.decode(response.bodyBytes);
    var errors = handleErrors(response, body, throwOnNotFound: false);
    if (errors.first.code == 404) return null;

    if (!rawStringResponse) {
      return json.decode(body);
    }

    return body;
  }

  Future<dynamic> post(Uri path,
      {dynamic body, bool rawStringResponse = false}) async {
    var headers = _authorizationHeader;
    if (body != null) {
      headers['Content-Type'] = 'application/json';
    }
    var response = await _client.post(path, headers: headers, body: body);
    String responseBody = utf8.decode(response.bodyBytes);
    handleErrors(response, responseBody);

    if (!rawStringResponse) {
      return json.decode(body);
    }

    return responseBody;
  }

  List<PartyError> handleErrors(http.Response response, String body,
      {bool throwOnNotFound = true}) {
    var isStatusSuccessful =
        response.statusCode >= 200 || response.statusCode < 300;
    if (isStatusSuccessful) return null;

    List<PartyError> errors = [];
    if (response.statusCode == 404) {
      var error = PartyError();
      error.code = response.statusCode;
      error.message = 'Could not find the requested resource';
      errors.add(error);
    }
    // Try to parse a detailed error response
    if (response.headers.containsKey('content-type') &&
        response.headers['content-type'].startsWith('application/json')) {
      try {
        var responseJson = json.decode(body);
        var document = ErrorDocument.fromJson(responseJson);
        errors.addAll(document.errors);
      } on Exception catch (ex) {
        var error = PartyError();
        error.code = response.statusCode;
        error.message = ex.toString();
        errors.add(error);
      }
    }

    if (response.statusCode == 404 && !throwOnNotFound) return errors;

    if (errors.isEmpty)
      throw ApiException(
          'Received an invalid response from the server (${response.statusCode})');

    throw ApiException.fromPartyErrors(errors);
  }
}
