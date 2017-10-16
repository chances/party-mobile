import 'package:owl/annotation/json.dart';

@JsonClass()
class Track {
  String id;

  String name;

  List<TrackArtist> artists;

  List<Image> images;

  String endpoint;

  @JsonField(key: 'began_playing')
  DateTime beganPlaying;

  int duration;

  String contributor;

  @JsonField(key: 'contributor_id')
  int contributorId;
}

@JsonClass()
class TrackArtist {
  String id;

  String name;
}

@JsonClass()
class Image {
  int height;

  int width;

  String url;
}
