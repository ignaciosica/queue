// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_artist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SpotifyArtist _$$_SpotifyArtistFromJson(Map<String, dynamic> json) =>
    _$_SpotifyArtist(
      name: json['name'] as String,
      uri: json['uri'] as String,
      id: json['id'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$$_SpotifyArtistToJson(_$_SpotifyArtist instance) =>
    <String, dynamic>{
      'name': instance.name,
      'uri': instance.uri,
      'id': instance.id,
      'type': instance.type,
    };
