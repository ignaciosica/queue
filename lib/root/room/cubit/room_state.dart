part of 'room_cubit.dart';

class RoomState extends Equatable {
  const RoomState(this.roomId);

  final String roomId;

  @override
  List<Object> get props => [roomId];
}
