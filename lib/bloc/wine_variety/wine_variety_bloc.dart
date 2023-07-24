import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/const/app_collections.dart';
import 'package:kevin/models/wine_variety_model.dart';
import 'package:kevin/services/app_firestore_service.dart';

part 'wine_variety_event.dart';
part 'wine_variety_state.dart';

class WineVarietyBloc extends Bloc<WineVarietyEvent, WineVarietyState> {
  AppFirestoreService appFirebase = AppFirestoreService();
  WineVarietyBloc() : super(WineVarietyInitial()) {
    on<CreateWineVarietyEvent>((event, emit) async {
      emit(LoadingState());
      try {
        final wineVarietyRef = appFirebase.createDoc(AppCollection.wineVarieties);
        final wineVarietyModel = WineVarietyModel(
          id: wineVarietyRef.id,
          title: event.title,
          code: event.code,
        );
        await wineVarietyRef.set(wineVarietyModel.toMap());

        emit(WineVarietySuccessState());
      } on FirebaseException catch (e) {
        emit(WineVarietyFailureState(e.message ?? "Error"));
      }
    });

    on<UpdateWineVarietyEvent>((event, emit) async {
      emit(LoadingState());
      try {
        await appFirebase.updateDoc(
          AppCollection.wineVarieties,
          event.wineVarietyModel.id,
          event.wineVarietyModel.toMap(),
        );

        emit(WineVarietySuccessState());
      } on FirebaseException catch (e) {
        emit(WineVarietyFailureState(e.message ?? "Error"));
      }
    });

    on<WineVarietyListEvent>((event, emit) async {
      emit(LoadingState());
      try {
        List<WineVarietyModel> list = [];
        await appFirebase.getList(AppCollection.wineVarieties).then((value) {
          for (var element in value.docs) {
            list.add(WineVarietyModel.fromMap(element.data()));
          }
        });
        emit(WineVarietyListSuccessState(list));
      } on FirebaseException catch (e) {
        emit(WineVarietyFailureState(e.message ?? "Error"));
      }
    });
  }
}
