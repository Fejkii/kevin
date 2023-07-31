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

class ShareProjectEvent extends ProjectEvent {
  final ProjectModel projectModel;
  final String email;
  const ShareProjectEvent({
    required this.projectModel,
    required this.email,
  });

  @override
  List<Object> get props => [projectModel, email];
}

class DeleteUserFromProjectEvent extends ProjectEvent {
  // TODO chybí v bloku logika
  final UserProjectModel userProjectModel;
  const DeleteUserFromProjectEvent({
    required this.userProjectModel,
  });

  @override
  List<Object> get props => [userProjectModel];
}
