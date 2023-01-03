// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'spotify_artist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SpotifyArtist _$SpotifyArtistFromJson(Map<String, dynamic> json) {
  return _SpotifyArtist.fromJson(json);
}

/// @nodoc
mixin _$SpotifyArtist {
  String get name => throw _privateConstructorUsedError;
  String get uri => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpotifyArtistCopyWith<SpotifyArtist> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotifyArtistCopyWith<$Res> {
  factory $SpotifyArtistCopyWith(
          SpotifyArtist value, $Res Function(SpotifyArtist) then) =
      _$SpotifyArtistCopyWithImpl<$Res, SpotifyArtist>;
  @useResult
  $Res call({String name, String uri, String id, String type});
}

/// @nodoc
class _$SpotifyArtistCopyWithImpl<$Res, $Val extends SpotifyArtist>
    implements $SpotifyArtistCopyWith<$Res> {
  _$SpotifyArtistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? uri = null,
    Object? id = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SpotifyArtistCopyWith<$Res>
    implements $SpotifyArtistCopyWith<$Res> {
  factory _$$_SpotifyArtistCopyWith(
          _$_SpotifyArtist value, $Res Function(_$_SpotifyArtist) then) =
      __$$_SpotifyArtistCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String uri, String id, String type});
}

/// @nodoc
class __$$_SpotifyArtistCopyWithImpl<$Res>
    extends _$SpotifyArtistCopyWithImpl<$Res, _$_SpotifyArtist>
    implements _$$_SpotifyArtistCopyWith<$Res> {
  __$$_SpotifyArtistCopyWithImpl(
      _$_SpotifyArtist _value, $Res Function(_$_SpotifyArtist) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? uri = null,
    Object? id = null,
    Object? type = null,
  }) {
    return _then(_$_SpotifyArtist(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _$_SpotifyArtist implements _SpotifyArtist {
  const _$_SpotifyArtist(
      {required this.name,
      required this.uri,
      required this.id,
      required this.type});

  factory _$_SpotifyArtist.fromJson(Map<String, dynamic> json) =>
      _$$_SpotifyArtistFromJson(json);

  @override
  final String name;
  @override
  final String uri;
  @override
  final String id;
  @override
  final String type;

  @override
  String toString() {
    return 'SpotifyArtist(name: $name, uri: $uri, id: $id, type: $type)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SpotifyArtist &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, uri, id, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SpotifyArtistCopyWith<_$_SpotifyArtist> get copyWith =>
      __$$_SpotifyArtistCopyWithImpl<_$_SpotifyArtist>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SpotifyArtistToJson(
      this,
    );
  }
}

abstract class _SpotifyArtist implements SpotifyArtist {
  const factory _SpotifyArtist(
      {required final String name,
      required final String uri,
      required final String id,
      required final String type}) = _$_SpotifyArtist;

  factory _SpotifyArtist.fromJson(Map<String, dynamic> json) =
      _$_SpotifyArtist.fromJson;

  @override
  String get name;
  @override
  String get uri;
  @override
  String get id;
  @override
  String get type;
  @override
  @JsonKey(ignore: true)
  _$$_SpotifyArtistCopyWith<_$_SpotifyArtist> get copyWith =>
      throw _privateConstructorUsedError;
}
