import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/models/project_model.dart';
import 'package:kevin/models/user_model.dart';
import 'package:kevin/models/user_project_model.dart';
import 'package:kevin/repository/project_repository.dart';
import 'package:kevin/repository/user_project_repository.dart';
import 'package:kevin/repository/user_repository.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  ProjectBloc() : super(ProjectInitial()) {
    final AppPreferences appPreferences = instance<AppPreferences>();
    final UserProjectRepository userProjectRepository = UserProjectRepository();
    final ProjectRepository projectRepository = ProjectRepository();
    final UserRepository userRepository = UserRepository();

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
      } on FirebaseException catch (e) {
        emit(ProjectFailureState(e.message ?? "Error"));
      }
    });

    on<ShareProjectEvent>((event, emit) async {
      emit(ShareProjectLoadingState());
      try {
        bool isDefault = false;
        UserModel? userModel = await userRepository.getUserByEmail(event.email);
        if (userModel != null) {
          // check if user has another userProject
          final userProject = await userProjectRepository.getDefaultUserProject(userModel.id);
          if (userProject == null) {
            isDefault = true;
          }
          userProjectRepository.createUserProject(userModel, event.projectModel, isDefault, false);
          emit(ShareProjectSuccessState());
        } else {
          emit(ShareProjectFailureState());
        }
      } on FirebaseException catch (e) {
        emit(ProjectFailureState(e.message ?? "Error"));
      }
    });

    on<UpdateProjectEvent>((event, emit) {
      emit(ProjectLoadingState());
      try {
        // TODO
        emit(ProjectSuccessState());
      } on FirebaseException catch (e) {
        emit(ProjectFailureState(e.message ?? "Error"));
      }
    });
  }
}
