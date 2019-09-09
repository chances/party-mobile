import 'dart:async';

import 'package:party/api/base.dart';
import 'package:party/api/endpoint.dart';
import 'package:party/models.dart' as models;

class Playback extends Endpoint {
  Playback(ApiBase api) : super(api);

  Future<models.PlayingTrack> play(bool shuffle) async {
    var params = {
      'type': 'play',
      'data': {'shuffle': shuffle}
    };
    var response = await api.post(route('/playback/play', params));
    var document = models.Document.fromJson(response);
    return document.data.getData(models.PlayingTrack.fromJson);
  }

  Future<models.PlayingTrack> pause(int elapsed) async {
    var params = {
      'type': 'pause',
      'data': {'elapsed': elapsed}
    };
    var response = await api.post(route('/playback/pause', params));
    var document = models.Document.fromJson(response);
    return document.data.getData(models.PlayingTrack.fromJson);
  }

  Future<models.PlayingTrack> resume() {
    return play(false);
  }

  Future<models.PlayingTrack> skip() async {
    var response = await api.post(route('/playback/skip'));
    var document = models.Document.fromJson(response);
    return document.data.getData(models.PlayingTrack.fromJson);
  }
}
