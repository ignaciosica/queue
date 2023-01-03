import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:groupify/common/common.dart';

part 'firestore_track.freezed.dart';
part 'firestore_track.g.dart';

@freezed
class FirestoreTrack with _$FirestoreTrack {
  const factory FirestoreTrack({
    @JsonKey(name: 'spotify_uri') required String spotifyUri,
    @JsonKey(name: 'created_at') @TimestampConverter() required Timestamp createdAt,
    required List<String> votes,
    @JsonKey(name: 'votes_count') required int votesCount,
  }) = _FirestoreTrack;

  factory FirestoreTrack.fromJson(Map<String, Object?> json) => _$FirestoreTrackFromJson(json);
}
