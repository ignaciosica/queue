part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = FormzStatus.pure,
    this.errorMessage,
  });

  final FormzStatus status;
  final String? errorMessage;

  @override
  List<Object> get props => [status];

  LoginState copyWith({
    FormzStatus? status,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
