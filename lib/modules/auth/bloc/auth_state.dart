// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthLoadingState extends AuthState {}

class LoginSuccessState extends AuthState {
  final UserModel userModel;
  const LoginSuccessState({
    required this.userModel,
  });

  @override
  List<Object> get props => [userModel];
}

class LogoutSuccessState extends AuthState {
  const LogoutSuccessState();
}

class AuthFailureState extends AuthState {
  final String errorMessage;
  const AuthFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class ForgotPasswordSendSuccessState extends AuthState {
  const ForgotPasswordSendSuccessState();
}
