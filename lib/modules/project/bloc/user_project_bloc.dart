import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/modules/auth/data/model/user_model.dart';
import 'package:kevin/modules/project/data/model/project_model.dart';
import 'package:kevin/modules/project/data/repository/user_project_repository.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';

import '../data/model/user_project_model.dart';

part 'user_project_event.dart';
part 'user_project_state.dart';

class UserProjectBloc extends Bloc<UserProjectEvent, UserProjectState> {
  UserProjectBloc() : super(UserProjectLoadingState()) {
    final UserProjectRepository userProjectRepository = UserProjectRepository();
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
  }
}
