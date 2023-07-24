import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kevin/models/user_model.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AppPreferences appPreferences = instance<AppPreferences>();

  AuthBloc() : super(const LoggedOutState()) {
    on<LogOutEvent>((event, emit) async {
      emit(AuthLoadingState());
      await appPreferences.logout();
      await FirebaseAuth.instance.signOut();
      emit(const LoggedOutState());
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
            );

            await appPreferences.setUser(userModel);
            emit(LoggedInState(userModel: userModel));
          }
        }
      } on FirebaseAuthException catch (e) {
        emit(AuthFailureState(e.message ?? "Auth Error"));
      }
    });

    on<LogInEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: event.email, password: event.password);

        if (userCredential.user != null) {
          UserModel userModel = UserModel(
            userCredential.user!.uid,
            userCredential.user!.email ?? "",
            userCredential.user!.displayName ?? "",
          );

          await appPreferences.setUser(userModel);
          emit(LoggedInState(userModel: userModel));
        }
      } on FirebaseAuthException catch (e) {
        emit(AuthFailureState(e.message ?? "Auth Error"));
      }
    });

    on<RegisterEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: event.email, password: event.password);

        if (userCredential.user != null) {
          UserModel userModel = UserModel(
            userCredential.user!.uid,
            userCredential.user!.email ?? "",
            userCredential.user!.displayName ?? "",
          );

          // TODO save userName

          await appPreferences.setUser(userModel);
          emit(LoggedInState(userModel: userModel));
        }
      } on FirebaseAuthException catch (e) {
        emit(AuthFailureState(e.message ?? "Auth Error"));
      }
    });

    on<ForgotPasswordEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: event.email);
        emit(const ForgotPasswordSendedState());
      } on FirebaseAuthException catch (e) {
        emit(AuthFailureState(e.message!));
      }
    });
  }
}
