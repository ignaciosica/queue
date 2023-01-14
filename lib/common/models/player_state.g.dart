// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PlayerState _$$_PlayerStateFromJson(Map<String, dynamic> json) => _$_PlayerState(
      isPaused: json['is_paused'] as bool,
      uri: json['uri'] as String,
      duration: json['duration'] as int,
      playbackPosition: json['playback_position'] as int,
    );

Map<String, dynamic> _$$_PlayerStateToJson(_$_PlayerState instance) => <String, dynamic>{
      'is_paused': instance.isPaused,
      'uri': instance.uri,
      'duration': instance.duration,
      'playback_position': instance.playbackPosition,
    };
