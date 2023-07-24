part of 'project_bloc.dart';

abstract class ProjectEvent extends Equatable {
  const ProjectEvent();

  @override
  List<Object> get props => [];
}

class CreateProjectEvent extends ProjectEvent {
  final String title;
  final bool isDefault;
  const CreateProjectEvent({
    required this.title,
    required this.isDefault,
  });

  @override
  List<Object> get props => [title];
}

class UpdateProjectEvent extends ProjectEvent {
  final ProjectModel projectModel;
  const UpdateProjectEvent({
    required this.projectModel,
  });

  @override
  List<Object> get props => [projectModel];
}
