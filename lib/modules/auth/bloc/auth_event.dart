// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class GoogleLogeIn extends AuthEvent {
  const GoogleLogeIn();

  @override
  List<Object> get props => [];
}

class LogInEvent extends AuthEvent {
  final String email;
  final String password;

  const LogInEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String userName;
  final String email;
  final String password;

  const RegisterEvent({
    required this.userName,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [userName, email, password];
}

class LogOutEvent extends AuthEvent {
  const LogOutEvent();
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;
  const ForgotPasswordEvent({
    required this.email,
  });

  @override
  List<Object> get props => [email];
}
