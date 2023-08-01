import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/modules/auth/data/model/user_model.dart';
import 'package:kevin/modules/project/data/model/project_model.dart';
import 'package:kevin/modules/project/data/repository/user_project_repository.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';

import '../../auth/data/repository/user_repository.dart';
import '../data/model/user_project_model.dart';

part 'user_project_event.dart';
part 'user_project_state.dart';

class UserProjectBloc extends Bloc<UserProjectEvent, UserProjectState> {
  UserProjectBloc() : super(UserProjectLoadingState()) {
    final UserProjectRepository userProjectRepository = UserProjectRepository();
    final UserRepository userRepository = UserRepository();
    final AppPreferences appPreferences = instance<AppPreferences>();

    on<UserProjectListByProjectEvent>((event, emit) async {
      emit(UserProjectLoadingState());
      try {
        List<UserProjectModel> list = await userProjectRepository.getUserProjectListByProject(event.projectModel.id);
        emit(UserProjectListSuccessState(list));
      } on Exception catch (e) {
        emit(UserProjectFailureState(e.toString()));
      }
    });

    on<UserProjectListByUserEvent>((event, emit) async {
      emit(UserProjectLoadingState());
      try {
        late List<UserProjectModel> list;
        list = await userProjectRepository.getUserProjectListByUser(event.userModel.id);
        emit(UserProjectListSuccessState(list));
      } on Exception catch (e) {
        emit(UserProjectFailureState(e.toString()));
      }
    });

    on<SetProjectDefaultEvent>((event, emit) async {
      emit(UserProjectLoadingState());
      try {
        UserProjectModel userProjectModel = await userProjectRepository.setProjectDefault(appPreferences.getUser(), event.userProjectModel);
        await appPreferences.setUserProject(userProjectModel);
        emit(UpdateUserProjectSuccessState());
      } on Exception catch (e) {
        emit(UserProjectFailureState(e.toString()));
      }
    });

    on<DeleteUserFromProjectEvent>((event, emit) async {
      emit(UserProjectLoadingState());
      try {
        if (event.userProjectModel.id != appPreferences.getUserProject().id) {
          await userProjectRepository.deleteUserFromProject(event.userProjectModel);
          emit(DeleteUserProjectSuccessState());
        } else {
          emit(DeleteUserProjectFailureState());
        }
      } on Exception catch (e) {
        emit(UserProjectFailureState(e.toString()));
      }
    });

    on<ShareProjectEvent>((event, emit) async {
      emit(ShareProjectLoadingState());
      try {
        bool isDefault = false;
        bool hasThisProject = false;
        UserModel? userModel = await userRepository.getUserByEmail(event.email);

        if (userModel != null) {
          List<UserProjectModel> userProjectList = await userProjectRepository.getUserProjectListByUser(userModel.id);
          // check if user has another userProject
          if (userProjectList.isEmpty) {
            isDefault = true;
          }
          for (var element in userProjectList) {
            // check if user has already this project
            if (element.id != appPreferences.getUserProject().id) {
              hasThisProject = true;
            }
          }
          if (!hasThisProject) {
            userProjectRepository.createUserProject(userModel, event.projectModel, isDefault, false);
            emit(ShareProjectSuccessState());
          } else {
            emit(ShareProjectFailureState());
          }
        } else {
          emit(ShareProjectFailureState());
        }
      } on Exception catch (e) {
        emit(UserProjectFailureState(e.toString()));
      }
    });
  }
}
