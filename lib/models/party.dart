import 'package:owl/annotation/json.dart';

import 'package:party/models/track.dart';

@JsonClass()
class Party {
  @JsonField(native: true)
  Map location;

  @JsonField(key: 'room_code')
  String roomCode;

  bool ended;

  List<Guest> guests;

  @JsonField(key: 'current_track', native: true)
  set currentTrackJson(Map json) => currentTrack = PlayingTrack.parse(json);
  @JsonField(key: 'current_track', native: true)
  Map get currentTrackJson => PlayingTrack.toJson(currentTrack);

  @Transient()
  PlayingTrack currentTrack;
}

@JsonClass()
class Guest {
  String name;

  String alias;

  @JsonField(key: 'checked_in')
  bool checkedIn;
}
