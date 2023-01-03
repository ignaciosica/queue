// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spotify_album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SpotifyAlbum _$$_SpotifyAlbumFromJson(Map<String, dynamic> json) =>
    _$_SpotifyAlbum(
      artists: (json['artists'] as List<dynamic>)
          .map((e) => SpotifyArtist.fromJson(e as Map<String, dynamic>))
          .toList(),
      images: (json['images'] as List<dynamic>)
          .map((e) => SpotifyImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      type: json['type'] as String,
      name: json['name'] as String,
      uri: json['uri'] as String,
      id: json['id'] as String,
    );

Map<String, dynamic> _$$_SpotifyAlbumToJson(_$_SpotifyAlbum instance) =>
    <String, dynamic>{
      'artists': instance.artists.map((e) => e.toJson()).toList(),
      'images': instance.images.map((e) => e.toJson()).toList(),
      'type': instance.type,
      'name': instance.name,
      'uri': instance.uri,
      'id': instance.id,
    };
