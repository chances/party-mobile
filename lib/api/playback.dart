import 'dart:async';

import 'package:party/api/base.dart';
import 'package:party/api/endpoint.dart';

class Playback extends Endpoint {
  Playback(ApiBase api) : super(api);

  Future<Null> play(bool shuffle) async {
    var params = shuffle ? { 'shuffle': 'yes' } : null;
    await api.post(route('/playback/play', params));
  }

  Future<Null> pause(int elapsed) async {
    var params = { 'elapsed': '$elapsed' };
    await api.post(route('/playback/pause', params));
  }

  Future<Null> resume() {
    return play(false);
  }

  Future<Null> skip() async {
    await api.post(route('/playback/skip'));
  }
}
