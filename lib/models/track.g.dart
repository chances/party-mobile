// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Track _$TrackFromJson(Map<String, dynamic> json) {
  return new Track()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..artists = (json['artists'] as List)
        ?.map((e) => e == null
            ? null
            : new TrackArtist.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..images = (json['images'] as List)
        ?.map((e) =>
            e == null ? null : new Image.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..endpoint = json['endpoint'] as String
    ..beganPlayingNative = json['began_playing'] as String
    ..duration = json['duration'] as int
    ..contributor = json['contributor'] as String
    ..contributorId = json['contributor_id'] as int;
}

abstract class _$TrackSerializerMixin {
  String get id;
  String get name;
  List<TrackArtist> get artists;
  List<Image> get images;
  String get endpoint;
  String get beganPlayingNative;
  int get duration;
  String get contributor;
  int get contributorId;
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'artists': artists,
        'images': images,
        'endpoint': endpoint,
        'began_playing': beganPlayingNative,
        'duration': duration,
        'contributor': contributor,
        'contributor_id': contributorId
      };
}

TrackArtist _$TrackArtistFromJson(Map<String, dynamic> json) {
  return new TrackArtist()
    ..id = json['id'] as String
    ..name = json['name'] as String;
}

abstract class _$TrackArtistSerializerMixin {
  String get id;
  String get name;
  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'name': name};
}

Image _$ImageFromJson(Map<String, dynamic> json) {
  return new Image()
    ..height = json['height'] as int
    ..width = json['width'] as int
    ..url = json['url'] as String;
}

abstract class _$ImageSerializerMixin {
  int get height;
  int get width;
  String get url;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'height': height, 'width': width, 'url': url};
}
