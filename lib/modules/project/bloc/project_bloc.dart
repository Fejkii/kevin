import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/modules/project/data/model/project_model.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';

import '../data/model/user_project_model.dart';
import '../data/repository/project_repository.dart';
import '../data/repository/user_project_repository.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  ProjectBloc() : super(ProjectInitial()) {
    final AppPreferences appPreferences = instance<AppPreferences>();
    final UserProjectRepository userProjectRepository = UserProjectRepository();
    final ProjectRepository projectRepository = ProjectRepository();

    on<CreateProjectEvent>((event, emit) async {
      emit(ProjectLoadingState());
      late ProjectModel projectModel;
      late UserProjectModel userProjectModel;
      bool isDefault = false;
      try {
        projectModel = await projectRepository.createProject(event.title);
        // check if user has another userProject
        final userProject = await userProjectRepository.getDefaultUserProject(appPreferences.getUser().id);
        if (userProject != null) {
          isDefault = event.isDefault;
        } else {
          isDefault = true;
        }

        userProjectModel = await userProjectRepository.createUserProject(
          appPreferences.getUser(),
          projectModel,
          isDefault,
          true,
        );
        appPreferences.setUserProject(userProjectModel);
        emit(ProjectSuccessState());
      } on Exception catch (e) {
        emit(ProjectFailureState(e.toString()));
      }
    });

    on<UpdateProjectEvent>((event, emit) async {
      emit(ProjectLoadingState());
      try {
        await projectRepository.updateProject(event.projectModel);
        UserProjectModel userProjectModel = appPreferences.getUserProject();
        userProjectModel.project = event.projectModel;
        await appPreferences.setUserProject(userProjectModel);
        emit(ProjectSuccessState());
      } on Exception catch (e) {
        emit(ProjectFailureState(e.toString()));
      }
    });
  }
}
