import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/const/app_collections.dart';
import 'package:kevin/entities/user_project_entity.dart';
import 'package:kevin/models/project_model.dart';
import 'package:kevin/models/user_project_model.dart';
import 'package:kevin/services/app_firestore_service.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';

part 'project_event.dart';
part 'project_state.dart';

class ProjectBloc extends Bloc<ProjectEvent, ProjectState> {
  ProjectBloc() : super(ProjectInitial()) {
    AppFirestoreService appFirebase = AppFirestoreService();
    final AppPreferences appPreferences = instance<AppPreferences>();

    on<CreateProjectEvent>((event, emit) async {
      late ProjectModel projectModel;
      late UserProjectModel userProjectModel;
      emit(ProjectLoadingState());
      try {
        final projectRef = appFirebase.createDoc(AppCollection.projects);
        projectModel = ProjectModel(
          id: projectRef.id,
          title: event.title,
        );
        projectRef.set(projectModel.toMap());

        final userProjectRef = appFirebase.createDoc(AppCollection.userProjects);

        userProjectModel = UserProjectModel(
          id: userProjectRef.id,
          user: appPreferences.getUser()!,
          project: projectModel,
          isDefault: event.isDefault,
          isOwner: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        userProjectRef.set(
          UserProjectEntity(
            id: userProjectRef.id,
            userId: userProjectModel.user.id,
            projectId: projectModel.id,
            isDefault: userProjectModel.isDefault,
            isOwner: userProjectModel.isOwner,
            createdAt: userProjectModel.createdAt,
            updatedAt: userProjectModel.updatedAt,
          ).toMap(),
        );

        appPreferences.setUserProject(userProjectModel);

        emit(ProjectSuccessState());
      } on FirebaseException catch (e) {
        emit(CreateProjectFailureState(e.message ?? "Error"));
      }
    });

    on<UpdateProjectEvent>((event, emit) {
      emit(ProjectLoadingState());
      try {
        // TODO
        emit(ProjectSuccessState());
      } on FirebaseException catch (e) {
        emit(CreateProjectFailureState(e.message ?? "Error"));
      }
    });
  }
}
