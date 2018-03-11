import 'package:owl/annotation/json.dart';
import 'package:party/models/track.json.g.dart';

@JsonClass()
class Track {
  String id;

  String name;

  List<TrackArtist> artists;

  List<Image> images;

  String endpoint;

  @JsonField(key: 'began_playing')
  String get beganPlayingNative => _beganPlaying?.toIso8601String();
  @JsonField(key: 'began_playing')
  set beganPlayingNative(String dateTime) {
    _beganPlaying =
        DateTime.parse(dateTime.split('.').first + '.000000Z').toUtc();
  }

  @Transient()
  DateTime _beganPlaying;
  @Transient()
  DateTime get beganPlaying => _beganPlaying;

  int duration;

  String contributor;

  @JsonField(key: 'contributor_id')
  int contributorId;
}

class PlayingTrack extends Track {
  PlayingTrack.fromTrack(Track track) {
    id = track.id;
    name = track.name;
    artists = track.artists;
    images = track.images;
    endpoint = track.endpoint;
    _beganPlaying = track.beganPlaying;
    duration = track.duration;
    contributor = track.contributor;
    contributorId = track.contributorId;
  }

  bool paused = true;

  int elapsed;

  bool isAdded = false;

  bool get isQueued => elapsed == null;
  bool get isPlaying => !paused;

  static PlayingTrack parse(Map<String, dynamic> json) {
    if (json == null) return null;
    Track t = TrackMapper.parse(json);
    PlayingTrack track = new PlayingTrack.fromTrack(t);
    return track;
  }

  static Map toJson(PlayingTrack track) {
    track.beganPlayingNative = track.beganPlaying.toIso8601String();
    Map json = TrackMapper.map(track);
    return json;
  }
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
