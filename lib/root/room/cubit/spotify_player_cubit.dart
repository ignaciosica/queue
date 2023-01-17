import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/models/track.dart';

part 'spotify_player_state.dart';

class SpotifyPlayerCubit extends Cubit<SpotifyPlayerState> {
  SpotifyPlayerCubit() : super(const SpotifyPlayerState());

  void playerStateChanged(PlayerState? playerState) {
    emit(SpotifyPlayerState.fromPlayerState(playerState));
  }
}
