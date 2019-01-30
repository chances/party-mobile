import 'package:json_annotation/json_annotation.dart';

import 'package:party/models/track.dart';

part 'party.g.dart';

Map rawMapFromJson(Map json) => json;
Map rawMapToJson(Map json) => json;

@JsonSerializable(createToJson: false)
class Party extends Object {
  Party();
  static Party fromJson(Map<String, dynamic> json) => _$PartyFromJson(json);

  @JsonKey(fromJson: rawMapFromJson, toJson: rawMapToJson)
  Map location;

  @JsonKey(name: 'room_code')
  String roomCode;

  bool ended;

  List<Guest> guests;

  @JsonKey(
      name: 'current_track', fromJson: rawMapFromJson, toJson: rawMapToJson)
  set currentTrackJson(Map json) =>
      json != null ? currentTrack = PlayingTrack.fromJson(json) : null;
  @JsonKey(
      name: 'current_track', fromJson: rawMapFromJson, toJson: rawMapToJson)
  Map get currentTrackJson => currentTrack.toJson();

  @JsonKey(ignore: true)
  PlayingTrack currentTrack;
}

@JsonSerializable(createToJson: false)
class Guest extends Object {
  Guest();
  static Guest fromJson(Map<String, dynamic> json) => _$GuestFromJson(json);

  String name;

  String alias;

  @JsonKey(name: 'checked_in')
  bool checkedIn;
}
