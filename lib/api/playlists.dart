import 'dart:async';

import 'package:party/api/base.dart';
import 'package:party/api/cache.dart';
import 'package:party/api/endpoint.dart';
import 'package:party/models.dart' as models;

class Playlists extends Endpoint {
  Playlists(ApiBase api) : super(api);

  Future<models.Playlist> get() async {
    return Cache.get<models.Playlist>('partyPlaylist', defer: () async {
      var response = await api.get(route('/playlist'));
      var document = models.Document.fromJson(response);
      var playlist = document.data.getData(models.Playlist.fromJson);
      return CacheEntry.expiresAfter(playlist, minutes: 15);
    });
  }
}
