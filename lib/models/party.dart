import 'package:json_annotation/json_annotation.dart';

import 'package:party/models/track.dart';

part 'party.g.dart';

Map rawMapFromJson(Map json) => json;
Map rawMapToJson(Map json) => json;

@JsonSerializable()
class Party extends Object with _$PartySerializerMixin {
  Party();
  factory Party.fromJson(Map<String, dynamic> json) => _$PartyFromJson(json);

  @JsonKey(fromJson: rawMapFromJson, toJson: rawMapToJson)
  Map location;

  @JsonKey(name: 'room_code')
  String roomCode;

  bool ended;

  List<Guest> guests;

  @JsonKey(name: 'current_track', fromJson: rawMapFromJson, toJson: rawMapToJson)
  set currentTrackJson(Map json) => currentTrack = PlayingTrack.fromJson(json);
  @JsonKey(name: 'current_track', fromJson: rawMapFromJson, toJson: rawMapToJson)
  Map get currentTrackJson => currentTrack.toJson();

  @JsonKey(ignore: true)
  PlayingTrack currentTrack;
}

@JsonSerializable()
class Guest extends Object with _$GuestSerializerMixin {
  Guest();
  factory Guest.fromJson(Map<String, dynamic> json) => _$GuestFromJson(json);

  String name;

  String alias;

  @JsonKey(name: 'checked_in')
  bool checkedIn;
}
