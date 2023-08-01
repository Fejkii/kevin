part of 'user_project_bloc.dart';

abstract class UserProjectState extends Equatable {
  const UserProjectState();

  @override
  List<Object> get props => [];
}

class UserProjectLoadingState extends UserProjectState {}

class UserProjectFailureState extends UserProjectState {
  final String errorMessage;
  const UserProjectFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class UpdateUserProjectSuccessState extends UserProjectState {}

class DeleteUserProjectSuccessState extends UserProjectState {}

class DeleteUserProjectFailureState extends UserProjectState {}

class UserProjectListSuccessState extends UserProjectState {
  final List<UserProjectModel> userProjectList;
  const UserProjectListSuccessState(this.userProjectList);

  @override
  List<Object> get props => [userProjectList];
}

class ShareProjectLoadingState extends UserProjectState {}

class ShareProjectSuccessState extends UserProjectState {}

class ShareProjectFailureState extends UserProjectState {}