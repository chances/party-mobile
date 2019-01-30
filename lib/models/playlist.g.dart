// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Playlist _$PlaylistFromJson(Map<String, dynamic> json) {
  return Playlist()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..images = (json['images'] as List)
        ?.map(
            (e) => e == null ? null : Image.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..owner = json['owner'] as String
    ..endpoint = json['endpoint'] as String
    ..totalTracks = json['total_tracks'] as int;
}
