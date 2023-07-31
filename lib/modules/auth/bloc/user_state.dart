part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
  
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoadingState extends UserState {}

class CreateUserNameState extends UserState {}

class UpdateUserSuccessState extends UserState {}

class UserNameSuccessState extends UserState {}

class UserFailureState extends UserState {
  final String errorMessage;
  const UserFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}