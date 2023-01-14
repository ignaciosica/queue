import 'package:freezed_annotation/freezed_annotation.dart';

part 'firestore_user.freezed.dart';
part 'firestore_user.g.dart';

@freezed
class FirestoreUser with _$FirestoreUser {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory FirestoreUser({
    required String id,
    required String name,
    String? profileUrl,
  }) = _FirestoreUser;

  factory FirestoreUser.fromJson(Map<String, dynamic> json) => _$FirestoreUserFromJson(json);
}
