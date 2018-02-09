// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: JsonGenerator
// **************************************************************************

// Generated by owl 0.2.2
// https://github.com/agilord/owl

// ignore: unused_import, library_prefixes
import 'track.dart';
// ignore: unused_import, library_prefixes
import 'dart:convert';
// ignore: unused_import, library_prefixes
import 'package:owl/util/json/core.dart' as _owl_json;

/// Mapper for Track
abstract class TrackMapper {
  /// Converts an instance of Track to Map.
  static Map<String, dynamic> map(Track object) {
    if (object == null) return null;
    return (new _owl_json.MapBuilder(ordered: false)
          ..put('id', object.id)
          ..put('name', object.name)
          ..put('artists', object.artists?.map(TrackArtistMapper.map)?.toList())
          ..put('images', object.images?.map(ImageMapper.map)?.toList())
          ..put('endpoint', object.endpoint)
          ..put('began_playing',
              _owl_json.DateTimeMapper.map(object.beganPlaying))
          ..put('duration', object.duration)
          ..put('contributor', object.contributor)
          ..put('contributor_id', object.contributorId))
        .toMap();
  }

  /// Converts a Map to an instance of Track.
  static Track parse(Map<String, dynamic> map) {
    if (map == null) return null;
    final Track object = new Track();
    object.id = map['id'];
    object.name = map['name'];

    // ignore: avoid_as
    object.artists = (map['artists'] as List<dynamic>)
        ?.map(TrackArtistMapper.parse)
        ?.toList();

    // ignore: avoid_as
    object.images =
        (map['images'] as List<dynamic>)?.map(ImageMapper.parse)?.toList();
    object.endpoint = map['endpoint'];
    object.beganPlaying = _owl_json.DateTimeMapper.parse(map['began_playing']);
    object.duration = map['duration'];
    object.contributor = map['contributor'];
    object.contributorId = map['contributor_id'];
    return object;
  }

  /// Converts a JSON string to an instance of Track.
  static Track fromJson(String json) {
    if (json == null || json.isEmpty) return null;
    final Map<String, dynamic> map = JSON.decoder.convert(json);
    return parse(map);
  }

  /// Converts an instance of Track to JSON string.
  static String toJson(Track object) {
    if (object == null) return null;
    return JSON.encoder.convert(map(object));
  }
}

/// Mapper for PlayingTrack
abstract class PlayingTrackMapper {
  /// Converts an instance of PlayingTrack to Map.
  static Map<String, dynamic> map(PlayingTrack object) {
    if (object == null) return null;
    return (new _owl_json.MapBuilder(ordered: false)
          ..put('paused', object.paused)
          ..put('elapsed', object.elapsed))
        .toMap();
  }

  /// Converts a Map to an instance of PlayingTrack.
  static PlayingTrack parse(Map<String, dynamic> map) {
    if (map == null) return null;
    final PlayingTrack object = new PlayingTrack();
    object.paused = map['paused'];
    object.elapsed = map['elapsed'];
    return object;
  }

  /// Converts a JSON string to an instance of PlayingTrack.
  static PlayingTrack fromJson(String json) {
    if (json == null || json.isEmpty) return null;
    final Map<String, dynamic> map = JSON.decoder.convert(json);
    return parse(map);
  }

  /// Converts an instance of PlayingTrack to JSON string.
  static String toJson(PlayingTrack object) {
    if (object == null) return null;
    return JSON.encoder.convert(map(object));
  }
}

/// Mapper for TrackArtist
abstract class TrackArtistMapper {
  /// Converts an instance of TrackArtist to Map.
  static Map<String, dynamic> map(TrackArtist object) {
    if (object == null) return null;
    return (new _owl_json.MapBuilder(ordered: false)
          ..put('id', object.id)
          ..put('name', object.name))
        .toMap();
  }

  /// Converts a Map to an instance of TrackArtist.
  static TrackArtist parse(Map<String, dynamic> map) {
    if (map == null) return null;
    final TrackArtist object = new TrackArtist();
    object.id = map['id'];
    object.name = map['name'];
    return object;
  }

  /// Converts a JSON string to an instance of TrackArtist.
  static TrackArtist fromJson(String json) {
    if (json == null || json.isEmpty) return null;
    final Map<String, dynamic> map = JSON.decoder.convert(json);
    return parse(map);
  }

  /// Converts an instance of TrackArtist to JSON string.
  static String toJson(TrackArtist object) {
    if (object == null) return null;
    return JSON.encoder.convert(map(object));
  }
}

/// Mapper for Image
abstract class ImageMapper {
  /// Converts an instance of Image to Map.
  static Map<String, dynamic> map(Image object) {
    if (object == null) return null;
    return (new _owl_json.MapBuilder(ordered: false)
          ..put('height', object.height)
          ..put('width', object.width)
          ..put('url', object.url))
        .toMap();
  }

  /// Converts a Map to an instance of Image.
  static Image parse(Map<String, dynamic> map) {
    if (map == null) return null;
    final Image object = new Image();
    object.height = map['height'];
    object.width = map['width'];
    object.url = map['url'];
    return object;
  }

  /// Converts a JSON string to an instance of Image.
  static Image fromJson(String json) {
    if (json == null || json.isEmpty) return null;
    final Map<String, dynamic> map = JSON.decoder.convert(json);
    return parse(map);
  }

  /// Converts an instance of Image to JSON string.
  static String toJson(Image object) {
    if (object == null) return null;
    return JSON.encoder.convert(map(object));
  }
}
