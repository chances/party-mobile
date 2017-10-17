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

  @JsonField(key: 'current_track')
  Track currentTrack;
}

@JsonClass()
class Guest {
  String name;

  String alias;

  @JsonField(key: 'ckecked_in')
  bool checkedIn;
}