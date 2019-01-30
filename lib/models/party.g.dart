// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'party.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Party _$PartyFromJson(Map<String, dynamic> json) {
  return Party()
    ..location = json['location'] == null
        ? null
        : rawMapFromJson(json['location'] as Map)
    ..roomCode = json['room_code'] as String
    ..ended = json['ended'] as bool
    ..guests = (json['guests'] as List)
        ?.map(
            (e) => e == null ? null : Guest.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..currentTrackJson = json['current_track'] == null
        ? null
        : rawMapFromJson(json['current_track'] as Map);
}

Guest _$GuestFromJson(Map<String, dynamic> json) {
  return Guest()
    ..name = json['name'] as String
    ..alias = json['alias'] as String
    ..checkedIn = json['checked_in'] as bool;
}
