part of 'app_bloc.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
}

class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.user = User.empty,
    //this.spotifyAccessToken = SpotifyAccessToken.empty,
    this.spotifyUserStatus = SpotifyUserStatus.empty,
  });

  const AppState.authenticated(User user, SpotifyUserStatus spotifyUserStatus)
      : this._(status: AppStatus.authenticated, user: user, spotifyUserStatus: spotifyUserStatus);

  const AppState.unauthenticated(User user, SpotifyUserStatus spotifyUserStatus)
      : this._(status: AppStatus.unauthenticated, user: user, spotifyUserStatus: spotifyUserStatus);

  final AppStatus status;
  final User user;
  //final SpotifyAccessToken spotifyAccessToken;
  final SpotifyUserStatus spotifyUserStatus;

  bool get googleAuthenticated => user != User.empty;
  bool get spotifyAuthenticated => spotifyUserStatus != SpotifyUserStatus.empty;

  @override
  List<Object> get props => [status, user, spotifyUserStatus];
}
