// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'spotify_track.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SpotifyTrack _$SpotifyTrackFromJson(Map<String, dynamic> json) {
  return _SpotifyTrack.fromJson(json);
}

/// @nodoc
mixin _$SpotifyTrack {
  String get name => throw _privateConstructorUsedError;
  int get durationMs => throw _privateConstructorUsedError;
  SpotifyAlbum get album => throw _privateConstructorUsedError;
  List<SpotifyArtist> get artists => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  String get uri => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpotifyTrackCopyWith<SpotifyTrack> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotifyTrackCopyWith<$Res> {
  factory $SpotifyTrackCopyWith(
          SpotifyTrack value, $Res Function(SpotifyTrack) then) =
      _$SpotifyTrackCopyWithImpl<$Res, SpotifyTrack>;
  @useResult
  $Res call(
      {String name,
      int durationMs,
      SpotifyAlbum album,
      List<SpotifyArtist> artists,
      String id,
      String uri,
      String type});

  $SpotifyAlbumCopyWith<$Res> get album;
}

/// @nodoc
class _$SpotifyTrackCopyWithImpl<$Res, $Val extends SpotifyTrack>
    implements $SpotifyTrackCopyWith<$Res> {
  _$SpotifyTrackCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? durationMs = null,
    Object? album = null,
    Object? artists = null,
    Object? id = null,
    Object? uri = null,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
      album: null == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as SpotifyAlbum,
      artists: null == artists
          ? _value.artists
          : artists // ignore: cast_nullable_to_non_nullable
              as List<SpotifyArtist>,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $SpotifyAlbumCopyWith<$Res> get album {
    return $SpotifyAlbumCopyWith<$Res>(_value.album, (value) {
      return _then(_value.copyWith(album: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_SpotifyTrackCopyWith<$Res>
    implements $SpotifyTrackCopyWith<$Res> {
  factory _$$_SpotifyTrackCopyWith(
          _$_SpotifyTrack value, $Res Function(_$_SpotifyTrack) then) =
      __$$_SpotifyTrackCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      int durationMs,
      SpotifyAlbum album,
      List<SpotifyArtist> artists,
      String id,
      String uri,
      String type});

  @override
  $SpotifyAlbumCopyWith<$Res> get album;
}

/// @nodoc
class __$$_SpotifyTrackCopyWithImpl<$Res>
    extends _$SpotifyTrackCopyWithImpl<$Res, _$_SpotifyTrack>
    implements _$$_SpotifyTrackCopyWith<$Res> {
  __$$_SpotifyTrackCopyWithImpl(
      _$_SpotifyTrack _value, $Res Function(_$_SpotifyTrack) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? durationMs = null,
    Object? album = null,
    Object? artists = null,
    Object? id = null,
    Object? uri = null,
    Object? type = null,
  }) {
    return _then(_$_SpotifyTrack(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      durationMs: null == durationMs
          ? _value.durationMs
          : durationMs // ignore: cast_nullable_to_non_nullable
              as int,
      album: null == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as SpotifyAlbum,
      artists: null == artists
          ? _value._artists
          : artists // ignore: cast_nullable_to_non_nullable
              as List<SpotifyArtist>,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      uri: null == uri
          ? _value.uri
          : uri // ignore: cast_nullable_to_non_nullable
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
class _$_SpotifyTrack implements _SpotifyTrack {
  const _$_SpotifyTrack(
      {required this.name,
      required this.durationMs,
      required this.album,
      required final List<SpotifyArtist> artists,
      required this.id,
      required this.uri,
      required this.type})
      : _artists = artists;

  factory _$_SpotifyTrack.fromJson(Map<String, dynamic> json) =>
      _$$_SpotifyTrackFromJson(json);

  @override
  final String name;
  @override
  final int durationMs;
  @override
  final SpotifyAlbum album;
  final List<SpotifyArtist> _artists;
  @override
  List<SpotifyArtist> get artists {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_artists);
  }

  @override
  final String id;
  @override
  final String uri;
  @override
  final String type;

  @override
  String toString() {
    return 'SpotifyTrack(name: $name, durationMs: $durationMs, album: $album, artists: $artists, id: $id, uri: $uri, type: $type)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SpotifyTrack &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.durationMs, durationMs) ||
                other.durationMs == durationMs) &&
            (identical(other.album, album) || other.album == album) &&
            const DeepCollectionEquality().equals(other._artists, _artists) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, durationMs, album,
      const DeepCollectionEquality().hash(_artists), id, uri, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SpotifyTrackCopyWith<_$_SpotifyTrack> get copyWith =>
      __$$_SpotifyTrackCopyWithImpl<_$_SpotifyTrack>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SpotifyTrackToJson(
      this,
    );
  }
}

abstract class _SpotifyTrack implements SpotifyTrack {
  const factory _SpotifyTrack(
      {required final String name,
      required final int durationMs,
      required final SpotifyAlbum album,
      required final List<SpotifyArtist> artists,
      required final String id,
      required final String uri,
      required final String type}) = _$_SpotifyTrack;

  factory _SpotifyTrack.fromJson(Map<String, dynamic> json) =
      _$_SpotifyTrack.fromJson;

  @override
  String get name;
  @override
  int get durationMs;
  @override
  SpotifyAlbum get album;
  @override
  List<SpotifyArtist> get artists;
  @override
  String get id;
  @override
  String get uri;
  @override
  String get type;
  @override
  @JsonKey(ignore: true)
  _$$_SpotifyTrackCopyWith<_$_SpotifyTrack> get copyWith =>
      throw _privateConstructorUsedError;
}
