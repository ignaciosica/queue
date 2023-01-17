// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'room.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Room _$RoomFromJson(Map<String, dynamic> json) {
  return _Room.fromJson(json);
}

/// @nodoc
mixin _$Room {
  String get name => throw _privateConstructorUsedError;
  List<String> get users => throw _privateConstructorUsedError;
  List<String> get skip => throw _privateConstructorUsedError;
  String get player => throw _privateConstructorUsedError;
  FirestorePlayerState get playerState => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RoomCopyWith<Room> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoomCopyWith<$Res> {
  factory $RoomCopyWith(Room value, $Res Function(Room) then) =
      _$RoomCopyWithImpl<$Res, Room>;
  @useResult
  $Res call(
      {String name,
      List<String> users,
      List<String> skip,
      String player,
      FirestorePlayerState playerState});

  $FirestorePlayerStateCopyWith<$Res> get playerState;
}

/// @nodoc
class _$RoomCopyWithImpl<$Res, $Val extends Room>
    implements $RoomCopyWith<$Res> {
  _$RoomCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? users = null,
    Object? skip = null,
    Object? player = null,
    Object? playerState = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<String>,
      skip: null == skip
          ? _value.skip
          : skip // ignore: cast_nullable_to_non_nullable
              as List<String>,
      player: null == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as String,
      playerState: null == playerState
          ? _value.playerState
          : playerState // ignore: cast_nullable_to_non_nullable
              as FirestorePlayerState,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FirestorePlayerStateCopyWith<$Res> get playerState {
    return $FirestorePlayerStateCopyWith<$Res>(_value.playerState, (value) {
      return _then(_value.copyWith(playerState: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_RoomCopyWith<$Res> implements $RoomCopyWith<$Res> {
  factory _$$_RoomCopyWith(_$_Room value, $Res Function(_$_Room) then) =
      __$$_RoomCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      List<String> users,
      List<String> skip,
      String player,
      FirestorePlayerState playerState});

  @override
  $FirestorePlayerStateCopyWith<$Res> get playerState;
}

/// @nodoc
class __$$_RoomCopyWithImpl<$Res> extends _$RoomCopyWithImpl<$Res, _$_Room>
    implements _$$_RoomCopyWith<$Res> {
  __$$_RoomCopyWithImpl(_$_Room _value, $Res Function(_$_Room) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? users = null,
    Object? skip = null,
    Object? player = null,
    Object? playerState = null,
  }) {
    return _then(_$_Room(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      users: null == users
          ? _value._users
          : users // ignore: cast_nullable_to_non_nullable
              as List<String>,
      skip: null == skip
          ? _value._skip
          : skip // ignore: cast_nullable_to_non_nullable
              as List<String>,
      player: null == player
          ? _value.player
          : player // ignore: cast_nullable_to_non_nullable
              as String,
      playerState: null == playerState
          ? _value.playerState
          : playerState // ignore: cast_nullable_to_non_nullable
              as FirestorePlayerState,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _$_Room with DiagnosticableTreeMixin implements _Room {
  const _$_Room(
      {required this.name,
      required final List<String> users,
      required final List<String> skip,
      required this.player,
      required this.playerState})
      : _users = users,
        _skip = skip;

  factory _$_Room.fromJson(Map<String, dynamic> json) => _$$_RoomFromJson(json);

  @override
  final String name;
  final List<String> _users;
  @override
  List<String> get users {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  final List<String> _skip;
  @override
  List<String> get skip {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skip);
  }

  @override
  final String player;
  @override
  final FirestorePlayerState playerState;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Room(name: $name, users: $users, skip: $skip, player: $player, playerState: $playerState)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Room'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('users', users))
      ..add(DiagnosticsProperty('skip', skip))
      ..add(DiagnosticsProperty('player', player))
      ..add(DiagnosticsProperty('playerState', playerState));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Room &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._users, _users) &&
            const DeepCollectionEquality().equals(other._skip, _skip) &&
            (identical(other.player, player) || other.player == player) &&
            (identical(other.playerState, playerState) ||
                other.playerState == playerState));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      const DeepCollectionEquality().hash(_users),
      const DeepCollectionEquality().hash(_skip),
      player,
      playerState);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RoomCopyWith<_$_Room> get copyWith =>
      __$$_RoomCopyWithImpl<_$_Room>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_RoomToJson(
      this,
    );
  }
}

abstract class _Room implements Room {
  const factory _Room(
      {required final String name,
      required final List<String> users,
      required final List<String> skip,
      required final String player,
      required final FirestorePlayerState playerState}) = _$_Room;

  factory _Room.fromJson(Map<String, dynamic> json) = _$_Room.fromJson;

  @override
  String get name;
  @override
  List<String> get users;
  @override
  List<String> get skip;
  @override
  String get player;
  @override
  FirestorePlayerState get playerState;
  @override
  @JsonKey(ignore: true)
  _$$_RoomCopyWith<_$_Room> get copyWith => throw _privateConstructorUsedError;
}
