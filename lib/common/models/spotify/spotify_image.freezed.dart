// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'spotify_image.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SpotifyImage _$SpotifyImageFromJson(Map<String, dynamic> json) {
  return _SpotifyImage.fromJson(json);
}

/// @nodoc
mixin _$SpotifyImage {
  int get width => throw _privateConstructorUsedError;
  int get height => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SpotifyImageCopyWith<SpotifyImage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpotifyImageCopyWith<$Res> {
  factory $SpotifyImageCopyWith(
          SpotifyImage value, $Res Function(SpotifyImage) then) =
      _$SpotifyImageCopyWithImpl<$Res, SpotifyImage>;
  @useResult
  $Res call({int width, int height, String url});
}

/// @nodoc
class _$SpotifyImageCopyWithImpl<$Res, $Val extends SpotifyImage>
    implements $SpotifyImageCopyWith<$Res> {
  _$SpotifyImageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? width = null,
    Object? height = null,
    Object? url = null,
  }) {
    return _then(_value.copyWith(
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SpotifyImageCopyWith<$Res>
    implements $SpotifyImageCopyWith<$Res> {
  factory _$$_SpotifyImageCopyWith(
          _$_SpotifyImage value, $Res Function(_$_SpotifyImage) then) =
      __$$_SpotifyImageCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int width, int height, String url});
}

/// @nodoc
class __$$_SpotifyImageCopyWithImpl<$Res>
    extends _$SpotifyImageCopyWithImpl<$Res, _$_SpotifyImage>
    implements _$$_SpotifyImageCopyWith<$Res> {
  __$$_SpotifyImageCopyWithImpl(
      _$_SpotifyImage _value, $Res Function(_$_SpotifyImage) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? width = null,
    Object? height = null,
    Object? url = null,
  }) {
    return _then(_$_SpotifyImage(
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _$_SpotifyImage implements _SpotifyImage {
  const _$_SpotifyImage(
      {required this.width, required this.height, required this.url});

  factory _$_SpotifyImage.fromJson(Map<String, dynamic> json) =>
      _$$_SpotifyImageFromJson(json);

  @override
  final int width;
  @override
  final int height;
  @override
  final String url;

  @override
  String toString() {
    return 'SpotifyImage(width: $width, height: $height, url: $url)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SpotifyImage &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, width, height, url);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SpotifyImageCopyWith<_$_SpotifyImage> get copyWith =>
      __$$_SpotifyImageCopyWithImpl<_$_SpotifyImage>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SpotifyImageToJson(
      this,
    );
  }
}

abstract class _SpotifyImage implements SpotifyImage {
  const factory _SpotifyImage(
      {required final int width,
      required final int height,
      required final String url}) = _$_SpotifyImage;

  factory _SpotifyImage.fromJson(Map<String, dynamic> json) =
      _$_SpotifyImage.fromJson;

  @override
  int get width;
  @override
  int get height;
  @override
  String get url;
  @override
  @JsonKey(ignore: true)
  _$$_SpotifyImageCopyWith<_$_SpotifyImage> get copyWith =>
      throw _privateConstructorUsedError;
}
