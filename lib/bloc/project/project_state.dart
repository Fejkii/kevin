part of 'project_bloc.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object> get props => [];
}

class ProjectInitial extends ProjectState {}

class ProjectLoadingState extends ProjectState {}

class ProjectSuccessState extends ProjectState {}

class ProjectFailureState extends ProjectState {
  final String errorMessage;
  const ProjectFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class ShareProjectLoadingState extends ProjectState {}

class ShareProjectSuccessState extends ProjectState {}

class ShareProjectFailureState extends ProjectState {}
