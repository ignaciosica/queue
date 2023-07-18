import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:groupify/common/common.dart';

part 'spotify_album.freezed.dart';
part 'spotify_album.g.dart';

@freezed
class SpotifyAlbum with _$SpotifyAlbum {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory SpotifyAlbum({
    required List<SpotifyArtist> artists,
    required List<SpotifyImage> images,
    required String type,
    required String name,
    required String uri,
    required String id,
  }) = _SpotifyAlbum;

  factory SpotifyAlbum.fromJson(Map<String, dynamic> json) => _$SpotifyAlbumFromJson(json);
}
