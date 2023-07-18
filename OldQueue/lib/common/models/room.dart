import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:groupify/common/models/player_state.dart';

part 'room.freezed.dart';
part 'room.g.dart';

@freezed
class Room with _$Room {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory Room({
    required String name,
    required List<String> users,
    required List<String> skip,
    required String player,
    required FirestorePlayerState playerState,
  }) = _Room;

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
}
