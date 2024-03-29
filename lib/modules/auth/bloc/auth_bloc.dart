import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kevin/const/app_collections.dart';
import 'package:kevin/modules/auth/data/model/user_model.dart';
import 'package:kevin/modules/auth/data/repository/user_repository.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';

import '../../project/data/model/user_project_model.dart';
import '../../project/data/repository/user_project_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AppPreferences appPreferences = instance<AppPreferences>();
  final UserRepository userRepository = UserRepository();
  final UserProjectRepository userProjectRepository = UserProjectRepository();

  AuthBloc() : super(const LogoutSuccessState()) {
    on<LogOutEvent>((event, emit) async {
      emit(AuthLoadingState());
      await appPreferences.logout();
      await FirebaseAuth.instance.signOut();
      emit(const LogoutSuccessState());
    });

    on<GoogleLogeIn>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleSignInAuthentication = await googleUser?.authentication;

        if (googleSignInAuthentication != null) {
          final credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken,
          );

          final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
          if (userCredential.user != null) {
            UserModel userModel = UserModel(
              userCredential.user!.uid,
              userCredential.user!.email ?? "",
              userCredential.user!.displayName ?? "",
              DateTime.now(),
              DateTime.now(),
            );
            await FirebaseFirestore.instance.collection(AppCollection.users).doc(userCredential.user!.uid).set(userModel.toMap());
            await appPreferences.setUser(userModel);
            final userProject = await userProjectRepository.getDefaultUserProject(userCredential.user!.uid);
            if (userProject != null) {
              await appPreferences.setUserProject(userProject);
            }
            emit(LoginSuccessState(userModel: userModel));
          }
        }
      } on FirebaseAuthException catch (e) {
        if (kDebugMode) {
          print("$e : ${e.message}");
        }
        emit(AuthFailureState(e.message ?? "Auth Error"));
      }
    });

    on<LogInEvent>((event, emit) async {
      emit(AuthLoadingState());
      appPreferences.clear();
      try {
        late UserModel userModel;
        late UserProjectModel? userProjectModel;
        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: event.email, password: event.password);
        if (userCredential.user != null) {
          userProjectModel = await userProjectRepository.getDefaultUserProject(userCredential.user!.uid);
          if (userProjectModel != null) {
            await appPreferences.setUserProject(userProjectModel);
            userModel = userProjectModel.user;
          } else {
            userModel = await userRepository.getUser(userCredential.user!.uid);
          }
          await appPreferences.setUser(userModel);
          emit(LoginSuccessState(userModel: userModel));
        } else {
          emit(const AuthFailureState("Login Auth Error"));
        }
      } on FirebaseAuthException catch (e) {
        if (kDebugMode) {
          print("$e : ${e.message}");
        }
        emit(AuthFailureState(e.message ?? "Login Auth Error"));
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(AuthLoadingState());
      appPreferences.clear();
      try {
        late UserModel userModel;
        late UserProjectModel? userProjectModel;
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: event.email, password: event.password);
        if (userCredential.user != null) {
          userProjectModel = await userProjectRepository.getDefaultUserProject(userCredential.user!.uid);
          if (userProjectModel != null) {
            appPreferences.setUserProject(userProjectModel);
            userModel = userProjectModel.user;
          } else {
            userModel = await userRepository.createUser(userCredential.user!.uid, event.userName, event.email);
          }
          await appPreferences.setUser(userModel);
          emit(LoginSuccessState(userModel: userModel));
        }
      } on FirebaseAuthException catch (e) {
        if (kDebugMode) {
          print("$e : ${e.message}");
        }
        emit(AuthFailureState(e.message ?? "Auth Error"));
      }
    });

    on<ForgotPasswordEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: event.email);
        emit(const ForgotPasswordSendSuccessState());
      } on FirebaseAuthException catch (e) {
        if (kDebugMode) {
          print("$e : ${e.message}");
        }
        emit(AuthFailureState(e.message!));
      }
    });
  }
}
