part of 'user_project_bloc.dart';

abstract class UserProjectEvent extends Equatable {
  const UserProjectEvent();

  @override
  List<Object> get props => [];
}

class UserProjectListByProjectEvent extends UserProjectEvent {
  final ProjectModel projectModel;
  const UserProjectListByProjectEvent({
    required this.projectModel,
  });

  @override
  List<Object> get props => [projectModel];
}

class UserProjectListByUserEvent extends UserProjectEvent {
  final UserModel userModel;
  const UserProjectListByUserEvent({
    required this.userModel,
  });

  @override
  List<Object> get props => [userModel];
}

class SetProjectDefaultEvent extends UserProjectEvent {
  final UserProjectModel userProjectModel;
  const SetProjectDefaultEvent({
    required this.userProjectModel,
  });

  @override
  List<Object> get props => [userProjectModel];
}

class DeleteUserFromProjectEvent extends UserProjectEvent {
  final UserProjectModel userProjectModel;
  const DeleteUserFromProjectEvent({
    required this.userProjectModel,
  });

  @override
  List<Object> get props => [userProjectModel];
}

class ShareProjectEvent extends UserProjectEvent {
  final ProjectModel projectModel;
  final String email;
  const ShareProjectEvent({
    required this.projectModel,
    required this.email,
  });

  @override
  List<Object> get props => [projectModel, email];
}