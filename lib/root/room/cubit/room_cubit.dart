import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'room_state.dart';

class RoomCubit extends HydratedCubit<RoomState> {
  RoomCubit(String roomId) : super(RoomState(roomId));

void setRoomId(String roomId) => emit(RoomState(roomId));

  @override
  RoomState fromJson(Map<String, dynamic> json) => RoomState(json['value'] ?? '');

  @override
  Map<String, String> toJson(RoomState state) => { 'value': state.roomId };
}
