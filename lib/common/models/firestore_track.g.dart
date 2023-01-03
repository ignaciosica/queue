// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firestore_track.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FirestoreTrack _$$_FirestoreTrackFromJson(Map<String, dynamic> json) =>
    _$_FirestoreTrack(
      spotifyUri: json['spotify_uri'] as String,
      createdAt: const TimestampConverter().fromJson(json['created_at']),
      votes: (json['votes'] as List<dynamic>).map((e) => e as String).toList(),
      votesCount: json['votes_count'] as int,
    );

Map<String, dynamic> _$$_FirestoreTrackToJson(_$_FirestoreTrack instance) =>
    <String, dynamic>{
      'spotify_uri': instance.spotifyUri,
      'created_at': const TimestampConverter().toJson(instance.createdAt),
      'votes': instance.votes,
      'votes_count': instance.votesCount,
    };
