// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'spotify_album.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SpotifyAlbum _$SpotifyAlbumFromJson(Map<String, dynamic> json) {
  return _SpotifyAlbum.fromJson(json);
}

/// @nodoc
mixin _$SpotifyAlbum {
  List<SpotifyArtist> get artists => throw _privateConstructorUsedError;
  List<SpotifyImage> get images => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get uri => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpotifyAlbumCopyWith<SpotifyAlbum> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotifyAlbumCopyWith<$Res> {
  factory $SpotifyAlbumCopyWith(
          SpotifyAlbum value, $Res Function(SpotifyAlbum) then) =
      _$SpotifyAlbumCopyWithImpl<$Res, SpotifyAlbum>;
  @useResult
  $Res call(
      {List<SpotifyArtist> artists,
      List<SpotifyImage> images,
      String type,
      String name,
      String uri,
      String id});
}

/// @nodoc
class _$SpotifyAlbumCopyWithImpl<$Res, $Val extends SpotifyAlbum>
    implements $SpotifyAlbumCopyWith<$Res> {
  _$SpotifyAlbumCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? artists = null,
    Object? images = null,
    Object? type = null,
    Object? name = null,
    Object? uri = null,
    Object? id = null,
  }) {
    return _then(_value.copyWith(
      artists: null == artists
          ? _value.artists
          : artists // ignore: cast_nullable_to_non_nullable
              as List<SpotifyArtist>,
      images: null == images
          ? _value.images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotifyImage>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SpotifyAlbumCopyWith<$Res>
    implements $SpotifyAlbumCopyWith<$Res> {
  factory _$$_SpotifyAlbumCopyWith(
          _$_SpotifyAlbum value, $Res Function(_$_SpotifyAlbum) then) =
      __$$_SpotifyAlbumCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<SpotifyArtist> artists,
      List<SpotifyImage> images,
      String type,
      String name,
      String uri,
      String id});
}

/// @nodoc
class __$$_SpotifyAlbumCopyWithImpl<$Res>
    extends _$SpotifyAlbumCopyWithImpl<$Res, _$_SpotifyAlbum>
    implements _$$_SpotifyAlbumCopyWith<$Res> {
  __$$_SpotifyAlbumCopyWithImpl(
      _$_SpotifyAlbum _value, $Res Function(_$_SpotifyAlbum) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? artists = null,
    Object? images = null,
    Object? type = null,
    Object? name = null,
    Object? uri = null,
    Object? id = null,
  }) {
    return _then(_$_SpotifyAlbum(
      artists: null == artists
          ? _value._artists
          : artists // ignore: cast_nullable_to_non_nullable
              as List<SpotifyArtist>,
      images: null == images
          ? _value._images
          : images // ignore: cast_nullable_to_non_nullable
              as List<SpotifyImage>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
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
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _$_SpotifyAlbum implements _SpotifyAlbum {
  const _$_SpotifyAlbum(
      {required final List<SpotifyArtist> artists,
      required final List<SpotifyImage> images,
      required this.type,
      required this.name,
      required this.uri,
      required this.id})
      : _artists = artists,
        _images = images;

  factory _$_SpotifyAlbum.fromJson(Map<String, dynamic> json) =>
      _$$_SpotifyAlbumFromJson(json);

  final List<SpotifyArtist> _artists;
  @override
  List<SpotifyArtist> get artists {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_artists);
  }

  final List<SpotifyImage> _images;
  @override
  List<SpotifyImage> get images {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  @override
  final String type;
  @override
  final String name;
  @override
  final String uri;
  @override
  final String id;

  @override
  String toString() {
    return 'SpotifyAlbum(artists: $artists, images: $images, type: $type, name: $name, uri: $uri, id: $id)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SpotifyAlbum &&
            const DeepCollectionEquality().equals(other._artists, _artists) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_artists),
      const DeepCollectionEquality().hash(_images),
      type,
      name,
      uri,
      id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SpotifyAlbumCopyWith<_$_SpotifyAlbum> get copyWith =>
      __$$_SpotifyAlbumCopyWithImpl<_$_SpotifyAlbum>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SpotifyAlbumToJson(
      this,
    );
  }
}

abstract class _SpotifyAlbum implements SpotifyAlbum {
  const factory _SpotifyAlbum(
      {required final List<SpotifyArtist> artists,
      required final List<SpotifyImage> images,
      required final String type,
      required final String name,
      required final String uri,
      required final String id}) = _$_SpotifyAlbum;

  factory _SpotifyAlbum.fromJson(Map<String, dynamic> json) =
      _$_SpotifyAlbum.fromJson;

  @override
  List<SpotifyArtist> get artists;
  @override
  List<SpotifyImage> get images;
  @override
  String get type;
  @override
  String get name;
  @override
  String get uri;
  @override
  String get id;
  @override
  @JsonKey(ignore: true)
  _$$_SpotifyAlbumCopyWith<_$_SpotifyAlbum> get copyWith =>
      throw _privateConstructorUsedError;
}
