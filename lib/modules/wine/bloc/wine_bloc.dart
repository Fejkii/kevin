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
        emit(WineSaveSuccessState());
      } on Exception catch (e) {
        emit(WineFailureState(e.toString()));
      }
    });

    on<UpdateWineEvent>((event, emit) async {
      emit(WineLoadingState());
      try {
        await wineRepository.updateWine(event.wineModel);
        emit(WineSaveSuccessState());
      } on Exception catch (e) {
        emit(WineFailureState(e.toString()));
      }
    });

    on<GetWineEvent>((event, emit) async {
      emit(WineLoadingState());
      try {
        await wineRepository.getWine(event.wineId);
        emit(WineLoadSuccessState());
      } on Exception catch (e) {
        emit(WineFailureState(e.toString()));
      }
    });

    on<GetWineListEvent>((event, emit) async {
      emit(WineLoadingState());
      try {
        final List<WineModel> list = await wineRepository.getAllWines();
        emit(WineListSuccessState(list));
      } on Exception catch (e) {
        emit(WineFailureState(e.toString()));
      }
    });
  }
}
