part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserNameEvent extends UserEvent {
  final UserModel userModel;
  final String name;

  const UserNameEvent({
    required this.userModel,
    required this.name,
  });

  @override
  List<Object> get props => [userModel, name];
}

class UpdateUserEvent extends UserEvent {
  final UserModel userModel;

  const UpdateUserEvent({
    required this.userModel,
  });

  @override
  List<Object> get props => [userModel];
}
