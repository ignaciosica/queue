import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_state.freezed.dart';
part 'player_state.g.dart';

@freezed
class FirestorePlayerState with _$FirestorePlayerState {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory FirestorePlayerState({
    required bool isPaused,
    required String uri,
    required int duration,
    required int playbackPosition,
    required List<String> artists,
    required String name,
    required String imageUri,
  }) = _PlayerState;

  factory FirestorePlayerState.fromJson(Map<String, dynamic> json) => _$FirestorePlayerStateFromJson(json);
}
