import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:groupify/common/common.dart';

part 'spotify_track.freezed.dart';
part 'spotify_track.g.dart';

@freezed
class SpotifyTrack with _$SpotifyTrack {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory SpotifyTrack({
    required String name,
    required int durationMs,
    required SpotifyAlbum album,
    required List<SpotifyArtist> artists,
    required String id,
    required String uri,
    required String type,
  }) = _SpotifyTrack;

  factory SpotifyTrack.fromJson(Map<String, dynamic> json) => _$SpotifyTrackFromJson(json);
}
