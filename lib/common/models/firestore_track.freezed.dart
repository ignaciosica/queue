// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'firestore_track.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FirestoreTrack _$FirestoreTrackFromJson(Map<String, dynamic> json) {
  return _FirestoreTrack.fromJson(json);
}

/// @nodoc
mixin _$FirestoreTrack {
  @JsonKey(name: 'spotify_uri')
  String get spotifyUri => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  @TimestampConverter()
  Timestamp get createdAt => throw _privateConstructorUsedError;
  List<String> get votes => throw _privateConstructorUsedError;
  @JsonKey(name: 'votes_count')
  int get votesCount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FirestoreTrackCopyWith<FirestoreTrack> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FirestoreTrackCopyWith<$Res> {
  factory $FirestoreTrackCopyWith(
          FirestoreTrack value, $Res Function(FirestoreTrack) then) =
      _$FirestoreTrackCopyWithImpl<$Res, FirestoreTrack>;
  @useResult
  $Res call(
      {@JsonKey(name: 'spotify_uri') String spotifyUri,
      @JsonKey(name: 'created_at') @TimestampConverter() Timestamp createdAt,
      List<String> votes,
      @JsonKey(name: 'votes_count') int votesCount});
}

/// @nodoc
class _$FirestoreTrackCopyWithImpl<$Res, $Val extends FirestoreTrack>
    implements $FirestoreTrackCopyWith<$Res> {
  _$FirestoreTrackCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? spotifyUri = null,
    Object? createdAt = null,
    Object? votes = null,
    Object? votesCount = null,
  }) {
    return _then(_value.copyWith(
      spotifyUri: null == spotifyUri
          ? _value.spotifyUri
          : spotifyUri // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as Timestamp,
      votes: null == votes
          ? _value.votes
          : votes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      votesCount: null == votesCount
          ? _value.votesCount
          : votesCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FirestoreTrackCopyWith<$Res>
    implements $FirestoreTrackCopyWith<$Res> {
  factory _$$_FirestoreTrackCopyWith(
          _$_FirestoreTrack value, $Res Function(_$_FirestoreTrack) then) =
      __$$_FirestoreTrackCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'spotify_uri') String spotifyUri,
      @JsonKey(name: 'created_at') @TimestampConverter() Timestamp createdAt,
      List<String> votes,
      @JsonKey(name: 'votes_count') int votesCount});
}

/// @nodoc
class __$$_FirestoreTrackCopyWithImpl<$Res>
    extends _$FirestoreTrackCopyWithImpl<$Res, _$_FirestoreTrack>
    implements _$$_FirestoreTrackCopyWith<$Res> {
  __$$_FirestoreTrackCopyWithImpl(
      _$_FirestoreTrack _value, $Res Function(_$_FirestoreTrack) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? spotifyUri = null,
    Object? createdAt = null,
    Object? votes = null,
    Object? votesCount = null,
  }) {
    return _then(_$_FirestoreTrack(
      spotifyUri: null == spotifyUri
          ? _value.spotifyUri
          : spotifyUri // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as Timestamp,
      votes: null == votes
          ? _value._votes
          : votes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      votesCount: null == votesCount
          ? _value.votesCount
          : votesCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FirestoreTrack implements _FirestoreTrack {
  const _$_FirestoreTrack(
      {@JsonKey(name: 'spotify_uri')
          required this.spotifyUri,
      @JsonKey(name: 'created_at')
      @TimestampConverter()
          required this.createdAt,
      required final List<String> votes,
      @JsonKey(name: 'votes_count')
          required this.votesCount})
      : _votes = votes;

  factory _$_FirestoreTrack.fromJson(Map<String, dynamic> json) =>
      _$$_FirestoreTrackFromJson(json);

  @override
  @JsonKey(name: 'spotify_uri')
  final String spotifyUri;
  @override
  @JsonKey(name: 'created_at')
  @TimestampConverter()
  final Timestamp createdAt;
  final List<String> _votes;
  @override
  List<String> get votes {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_votes);
  }

  @override
  @JsonKey(name: 'votes_count')
  final int votesCount;

  @override
  String toString() {
    return 'FirestoreTrack(spotifyUri: $spotifyUri, createdAt: $createdAt, votes: $votes, votesCount: $votesCount)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FirestoreTrack &&
            (identical(other.spotifyUri, spotifyUri) ||
                other.spotifyUri == spotifyUri) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._votes, _votes) &&
            (identical(other.votesCount, votesCount) ||
                other.votesCount == votesCount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, spotifyUri, createdAt,
      const DeepCollectionEquality().hash(_votes), votesCount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FirestoreTrackCopyWith<_$_FirestoreTrack> get copyWith =>
      __$$_FirestoreTrackCopyWithImpl<_$_FirestoreTrack>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FirestoreTrackToJson(
      this,
    );
  }
}

abstract class _FirestoreTrack implements FirestoreTrack {
  const factory _FirestoreTrack(
      {@JsonKey(name: 'spotify_uri')
          required final String spotifyUri,
      @JsonKey(name: 'created_at')
      @TimestampConverter()
          required final Timestamp createdAt,
      required final List<String> votes,
      @JsonKey(name: 'votes_count')
          required final int votesCount}) = _$_FirestoreTrack;

  factory _FirestoreTrack.fromJson(Map<String, dynamic> json) =
      _$_FirestoreTrack.fromJson;

  @override
  @JsonKey(name: 'spotify_uri')
  String get spotifyUri;
  @override
  @JsonKey(name: 'created_at')
  @TimestampConverter()
  Timestamp get createdAt;
  @override
  List<String> get votes;
  @override
  @JsonKey(name: 'votes_count')
  int get votesCount;
  @override
  @JsonKey(ignore: true)
  _$$_FirestoreTrackCopyWith<_$_FirestoreTrack> get copyWith =>
      throw _privateConstructorUsedError;
}
