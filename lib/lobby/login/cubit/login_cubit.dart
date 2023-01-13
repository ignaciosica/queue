import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:groupify/app/app.dart';
import 'package:groupify/auth/auth.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository, this._appBloc) : super(const LoginState());

  final AuthRepository _authenticationRepository;
  final AppBloc _appBloc;

  Future<void> logInWithSpotify() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.logInWithSpotify();
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
      _appBloc.add(AppUpdate());
    } on LogInWithSpotifyFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: FormzStatus.submissionFailure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  Future<void> logInWithGoogle() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.logInWithGoogle();
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
      await FirebaseFirestore.instance.collection('users').doc(_authenticationRepository.currentUser!.id).set({
        'name': _authenticationRepository.currentUser!.name,
        'profile_url': _authenticationRepository.currentUser!.photo,
        'active_room': '',
      });
      _appBloc.add(AppUpdate());
    } on LogInWithGoogleFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: FormzStatus.submissionFailure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
