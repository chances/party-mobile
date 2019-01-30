import 'package:json_annotation/json_annotation.dart';
import 'package:spotify/spotify_io.dart' show Image;

part 'playlist.g.dart';

@JsonSerializable(createToJson: false)
class Playlist extends Object {
  Playlist();
  static Playlist fromJson(Map<String, dynamic> json) =>
      _$PlaylistFromJson(json);

  String id;

  String name;

  List<Image> images;

  String owner;

  String endpoint;

  @JsonKey(name: 'total_tracks')
  int totalTracks;
}
