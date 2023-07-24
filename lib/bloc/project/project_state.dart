part of 'project_bloc.dart';

abstract class ProjectState extends Equatable {
  const ProjectState();

  @override
  List<Object> get props => [];
}

class ProjectInitial extends ProjectState {}

class ProjectLoadingState extends ProjectState {}

class ProjectSuccessState extends ProjectState {}

class CreateProjectFailureState extends ProjectState {
  final String errorMessage;
  const CreateProjectFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
