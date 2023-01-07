import 'package:freezed_annotation/freezed_annotation.dart';

import 'models.dart';

part 'room.freezed.dart';
part 'room.g.dart';

@freezed
class Room with _$Room {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory Room({required String name, required List<String> users, required List<String> skip}) = _Room;

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
}
