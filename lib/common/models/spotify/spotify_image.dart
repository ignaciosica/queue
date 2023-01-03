import 'package:freezed_annotation/freezed_annotation.dart';

part 'spotify_image.freezed.dart';
part 'spotify_image.g.dart';

@freezed
class SpotifyImage with _$SpotifyImage {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory SpotifyImage({
    required int width,
    required int height,
    required String url,
  }) = _SpotifyImage;

  factory SpotifyImage.fromJson(Map<String, dynamic> json) => _$SpotifyImageFromJson(json);
}
