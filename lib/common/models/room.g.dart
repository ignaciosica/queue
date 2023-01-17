// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Room _$$_RoomFromJson(Map<String, dynamic> json) => _$_Room(
      name: json['name'] as String,
      users: (json['users'] as List<dynamic>).map((e) => e as String).toList(),
      skip: (json['skip'] as List<dynamic>).map((e) => e as String).toList(),
      player: json['player'] as String,
      playerState: FirestorePlayerState.fromJson(
          json['player_state'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_RoomToJson(_$_Room instance) => <String, dynamic>{
      'name': instance.name,
      'users': instance.users,
      'skip': instance.skip,
      'player': instance.player,
      'player_state': instance.playerState.toJson(),
    };
