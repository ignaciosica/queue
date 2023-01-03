import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:groupify/auth/auth.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(_init(authenticationRepository)) {
    on<AppUserChanged>(_onUserChanged);
    on<AppSpotifyUserChanged>(_onSpotifyUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    on<AppUpdate>(_onUpdate);
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(AppUserChanged(user)),
    );
    _spotifyUserStatusSubscription = _authenticationRepository.spotifyUserStatus.listen(
      (spotifyAccessToken) => add(AppSpotifyUserChanged(spotifyAccessToken)),
    );
  }

  final AuthRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;
  late final StreamSubscription<SpotifyUserStatus> _spotifyUserStatusSubscription;

  static AppState _init(AuthRepository authRepo) {
    if (authRepo.currentUser.isNotEmpty && authRepo.currentSpotifyUserStatus.isNotEmpty) {
      return AppState.authenticated(authRepo.currentUser, authRepo.currentSpotifyUserStatus);
    } else {
      return AppState.unauthenticated(authRepo.currentUser, authRepo.currentSpotifyUserStatus);
    }
  }

  Future<void> _validateState(User user, SpotifyUserStatus spotifyUserStatus, Emitter<AppState> emit) async {
    if (user.isNotEmpty && spotifyUserStatus.isNotEmpty) {
      emit(AppState.authenticated(user, spotifyUserStatus));
    } else {
      emit(AppState.unauthenticated(user, spotifyUserStatus));
    }
  }

  Future<void> _onUserChanged(AppUserChanged event, Emitter<AppState> emit) async {
    _validateState(event.user, state.spotifyUserStatus, emit);
  }

  Future<void> _onSpotifyUserChanged(AppSpotifyUserChanged event, Emitter<AppState> emit) async {
    _validateState(_authenticationRepository.currentUser, event.spotifyUserStatus, emit);
  }

  Future<void> _onUpdate(AppUpdate event, Emitter<AppState> emit) async {
    _validateState(_authenticationRepository.currentUser, _authenticationRepository.currentSpotifyUserStatus, emit);
  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) async {
    await (_authenticationRepository.logOut());
    add(AppUpdate());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    _spotifyUserStatusSubscription.cancel();
    return super.close();
  }
}
