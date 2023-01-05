import 'package:freezed_annotation/freezed_annotation.dart';

part 'spotify_artist.freezed.dart';
part 'spotify_artist.g.dart';

@freezed
class SpotifyArtist with _$SpotifyArtist {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory SpotifyArtist({
    required String name,
    required String uri,
    required String id,
    required String type,
  }) = _SpotifyArtist;

  factory SpotifyArtist.fromJson(Map<String, dynamic> json) => _$SpotifyArtistFromJson(json);
}
