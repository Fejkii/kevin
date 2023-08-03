import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/modules/wine/data/repository/wine_record_repository.dart';

import '../data/model/wine_record_model.dart';

part 'wine_record_event.dart';
part 'wine_record_state.dart';

class WineRecordBloc extends Bloc<WineRecordEvent, WineRecordState> {
  final WineRecordRepository wineRecordRepository = WineRecordRepository();

  WineRecordBloc() : super(WineRecordInitial()) {
    on<CreateWineRecordEvent>((event, emit) async {
      emit(WineRecordLoadingState());
      try {
        await wineRecordRepository.createWineRecord(event.wineId, event.wineRecordModel);
        emit(WineRecordSuccessState());
      } on Exception catch (e) {
        WineRecordFailureState(e.toString());
      }
    });

    on<UpdateWineRecordEvent>((event, emit) {
      emit(WineRecordLoadingState());
      try {
        wineRecordRepository.updateWineRecord(event.wineId, event.wineRecordModel);
        emit(WineRecordSuccessState());
      } on Exception catch (e) {
        WineRecordFailureState(e.toString());
      }
    });

    on<WineRecordListEvent>((event, emit) async {
      emit(WineRecordLoadingState());
      try {
        final list = await wineRecordRepository.getWineRecordList(event.wineId);
        emit(WineRecordListSuccessState(list));
      } on Exception catch (e) {
        WineRecordFailureState(e.toString());
      }
    });
  }
}
