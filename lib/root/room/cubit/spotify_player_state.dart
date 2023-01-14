part of 'spotify_player_cubit.dart';

class SpotifyPlayerState extends Equatable {
  const SpotifyPlayerState({this.track, this.isPaused = true, this.playbackPosition = 0});

  final Track? track;
  final bool isPaused;
  final int playbackPosition;

  factory SpotifyPlayerState.fromPlayerState(PlayerState? ps) {
    return SpotifyPlayerState(track: ps?.track, isPaused: ps?.isPaused ?? true, playbackPosition: ps?.playbackPosition ?? 0);
  }

  @override
  List<Object> get props => [track?.uri ?? '', isPaused, playbackPosition];
}
