// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Track _$TrackFromJson(Map<String, dynamic> json) {
  return Track()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..artists = (json['artists'] as List)
        ?.map((e) =>
            e == null ? null : TrackArtist.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..images = (json['images'] as List)
        ?.map(
            (e) => e == null ? null : Image.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..endpoint = json['endpoint'] as String
    ..beganPlayingNative = json['began_playing'] as String
    ..duration = json['duration'] as int
    ..contributor = json['contributor'] as String
    ..contributorId = json['contributor_id'] as int;
}

Map<String, dynamic> _$TrackToJson(Track instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'artists': instance.artists,
      'images': instance.images,
      'endpoint': instance.endpoint,
      'began_playing': instance.beganPlayingNative,
      'duration': instance.duration,
      'contributor': instance.contributor,
      'contributor_id': instance.contributorId
    };

PlayingTrack _$PlayingTrackFromJson(Map<String, dynamic> json) {
  return PlayingTrack()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..artists = (json['artists'] as List)
        ?.map((e) =>
            e == null ? null : TrackArtist.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..images = (json['images'] as List)
        ?.map(
            (e) => e == null ? null : Image.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..endpoint = json['endpoint'] as String
    ..beganPlayingNative = json['began_playing'] as String
    ..duration = json['duration'] as int
    ..contributor = json['contributor'] as String
    ..contributorId = json['contributor_id'] as int
    ..paused = json['paused'] as bool
    ..elapsed = json['elapsed'] as int
    ..isAdded = json['isAdded'] as bool;
}

Map<String, dynamic> _$PlayingTrackToJson(PlayingTrack instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'artists': instance.artists,
      'images': instance.images,
      'endpoint': instance.endpoint,
      'began_playing': instance.beganPlayingNative,
      'duration': instance.duration,
      'contributor': instance.contributor,
      'contributor_id': instance.contributorId,
      'paused': instance.paused,
      'elapsed': instance.elapsed,
      'isAdded': instance.isAdded
    };

TrackArtist _$TrackArtistFromJson(Map<String, dynamic> json) {
  return TrackArtist()
    ..id = json['id'] as String
    ..name = json['name'] as String;
}

Map<String, dynamic> _$TrackArtistToJson(TrackArtist instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

Image _$ImageFromJson(Map<String, dynamic> json) {
  return Image()
    ..height = json['height'] as int
    ..width = json['width'] as int
    ..url = json['url'] as String;
}

Map<String, dynamic> _$ImageToJson(Image instance) => <String, dynamic>{
      'height': instance.height,
      'width': instance.width,
      'url': instance.url
    };
