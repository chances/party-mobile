// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'party.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Party _$PartyFromJson(Map<String, dynamic> json) {
  return new Party()
    ..location = json['location'] == null
        ? null
        : rawMapFromJson(json['location'] as Map)
    ..roomCode = json['room_code'] as String
    ..ended = json['ended'] as bool
    ..guests = (json['guests'] as List)
        ?.map((e) =>
            e == null ? null : new Guest.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..currentTrackJson = json['current_track'] == null
        ? null
        : rawMapFromJson(json['current_track'] as Map);
}

abstract class _$PartySerializerMixin {
  Map<dynamic, dynamic> get location;
  String get roomCode;
  bool get ended;
  List<Guest> get guests;
  Map<dynamic, dynamic> get currentTrackJson;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'location': location == null ? null : rawMapToJson(location),
        'room_code': roomCode,
        'ended': ended,
        'guests': guests,
        'current_track':
            currentTrackJson == null ? null : rawMapToJson(currentTrackJson)
      };
}

Guest _$GuestFromJson(Map<String, dynamic> json) {
  return new Guest()
    ..name = json['name'] as String
    ..alias = json['alias'] as String
    ..checkedIn = json['checked_in'] as bool;
}

abstract class _$GuestSerializerMixin {
  String get name;
  String get alias;
  bool get checkedIn;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'name': name, 'alias': alias, 'checked_in': checkedIn};
}
