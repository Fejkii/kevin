import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/modules/wine/data/model/wine_classification_model.dart';
import 'package:kevin/modules/wine/data/model/wine_model.dart';
import 'package:kevin/modules/wine/data/model/wine_variety_model.dart';
import 'package:kevin/modules/wine/data/repository/wine_repository.dart';

part 'wine_event.dart';
part 'wine_state.dart';

class WineBloc extends Bloc<WineEvent, WineState> {
  final WineRepository wineRepository = WineRepository();
  late final StreamSubscription? wineVarietyStream;

  WineBloc() : super(WineInitial()) {
    on<CreateWineEvent>((event, emit) async {
      emit(WineLoadingState());
      try {
        await wineRepository.createWine(
          event.title,
          event.wineVarieties,
          event.wineClassification,
          event.quantity,
          event.year,
          event.alcohol,
          event.acid,
          event.sugar,
          event.note,
        );
        emit(WineSuccessState());
      } on Exception catch (e) {
        emit(WineFailureState(e.toString()));
      }
    });

    on<UpdateWineEvent>((event, emit) async {
      emit(WineLoadingState());
      try {
        await wineRepository.updateWine(event.wineModel);
        emit(WineSuccessState());
      } on Exception catch (e) {
        emit(WineFailureState(e.toString()));
      }
    });

    on<WineListRequestEvent>((event, emit) async {
      emit(WineLoadingState());
      try {
        wineRepository.getAllWines().listen((list) {
          add(WineListReceivedEvent(list));
        });
      } on Exception catch (e) {
        emit(WineFailureState(e.toString()));
      }
    });

    on<WineListReceivedEvent>((event, emit) async {
      emit(WineLoadingState());
      emit(WineListSuccessState(event.winelist));
    });
  }
}
