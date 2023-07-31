import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/app_preferences.dart';
import '../../../services/dependency_injection.dart';
import '../data/model/user_model.dart';
import '../data/repository/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  final AppPreferences appPreferences = instance<AppPreferences>();

  UserBloc(
    this.userRepository,
  ) : super(UserInitial()) {
    on<UserNameEvent>((event, emit) async {
      emit(UserLoadingState());
      try {
        await userRepository.createUserName(event.userModel, event.name);
        emit(UserNameSuccessState());
      } on Exception catch (e) {
        emit(UserFailureState(e.toString()));
      }
    });

    on<UpdateUserEvent>((event, emit) async {
      emit(UserLoadingState());
      try {
        await userRepository.updateUser(event.userModel);

        await appPreferences.setUser(event.userModel);
        emit(UpdateUserSuccessState());
      } on Exception catch (e) {
        emit(UserFailureState(e.toString()));
      }
    });
  }
}
