// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SpotifyTrack _$$_SpotifyTrackFromJson(Map<String, dynamic> json) =>
    _$_SpotifyTrack(
      name: json['name'] as String,
      durationMs: json['duration_ms'] as int,
      album: SpotifyAlbum.fromJson(json['album'] as Map<String, dynamic>),
      artists: (json['artists'] as List<dynamic>)
          .map((e) => SpotifyArtist.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: json['id'] as String,
      uri: json['uri'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$$_SpotifyTrackToJson(_$_SpotifyTrack instance) =>
    <String, dynamic>{
      'name': instance.name,
      'duration_ms': instance.durationMs,
      'album': instance.album.toJson(),
      'artists': instance.artists.map((e) => e.toJson()).toList(),
      'id': instance.id,
      'uri': instance.uri,
      'type': instance.type,
    };
