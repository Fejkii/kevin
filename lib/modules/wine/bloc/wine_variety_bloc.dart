import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/modules/wine/data/model/wine_variety_model.dart';
import 'package:kevin/modules/wine/data/repository/wine_variety_repository.dart';

part 'wine_variety_event.dart';
part 'wine_variety_state.dart';

class WineVarietyBloc extends Bloc<WineVarietyEvent, WineVarietyState> {
  final WineVarietyRepository wineVarietyRepository;
  late final StreamSubscription? wineVarietyStream;

  WineVarietyBloc(this.wineVarietyRepository) : super(WineVarietyInitial()) {
    on<CreateWineVarietyEvent>((event, emit) async {
      emit(WineVarietyLoadingState());
      try {
        await wineVarietyRepository.createWineVariety(event.title, event.code);
        emit(WineVarietySuccessState());
      } on Exception catch (e) {
        emit(WineVarietyFailureState(e.toString()));
      }
    });

    on<UpdateWineVarietyEvent>((event, emit) async {
      emit(WineVarietyLoadingState());
      try {
        await wineVarietyRepository.updateWineVariety(event.wineVarietyModel);
        emit(WineVarietySuccessState());
      } on Exception catch (e) {
        emit(WineVarietyFailureState(e.toString()));
      }
    });

    on<WineVarietyListEvent>((event, emit) async {
      emit(WineVarietyLoadingState());
      try {
        List<WineVarietyModel> list = await wineVarietyRepository.getWineVarietyList();
        add(WineVarietyListReceivedEvent(list));
      } on Exception catch (e) {
        emit(WineVarietyFailureState(e.toString()));
      }
    });

    on<WineVarietyListRequestEvent>((event, emit) async {
      emit(WineVarietyLoadingState());
      try {
        wineVarietyRepository.getAllWineVarieties().listen((list) {
          add(WineVarietyListReceivedEvent(list));
        });
      } on Exception catch (e) {
        emit(WineVarietyFailureState(e.toString()));
      }
    });

    on<WineVarietyListReceivedEvent>((event, emit) async {
      emit(WineVarietyLoadingState());
      emit(WineVarietyListSuccessState(event.wineVarietylist));
    });
  }

  // @override
  // Future<void> close() {
  //   wineVarietyStream?.cancel();
  //   return super.close();
  // }
}
