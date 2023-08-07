import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/modules/vineyard/model/vineyard_record_model.dart';
import 'package:kevin/modules/vineyard/repository/vineyard_record_repository.dart';

part 'vineyard_record_event.dart';
part 'vineyard_record_state.dart';

class VineyardRecordBloc extends Bloc<VineyardRecordEvent, VineyardRecordState> {
  VineyardRecordRepository vineyardRecordRepository = VineyardRecordRepository();

  VineyardRecordBloc() : super(VineyardRecordInitial()) {
    on<CreateVineyardRecordEvent>((event, emit) async {
      emit(VineyardRecordLoadingState());
      try {
        await vineyardRecordRepository.createVineyardRecord(event.vineyardId, event.vineyardRecordModel);
        emit(VineyardRecordSuccessState());
      } on Exception catch (e) {
        emit(VineyardRecordFailureState(e.toString()));
      }
    });

    on<UpdateVineyardRecordEvent>((event, emit) async {
      emit(VineyardRecordLoadingState());
      try {
        await vineyardRecordRepository.updateVineyardRecord(event.vineyardId, event.vineyardRecordModel);
        emit(VineyardRecordSuccessState());
      } on Exception catch (e) {
        emit(VineyardRecordFailureState(e.toString()));
      }
    });

    on<VineyardRecordListEvent>((event, emit) async {
      emit(VineyardRecordLoadingState());
      try {
        List<VineyardRecordModel> vineyardRecordList = await vineyardRecordRepository.getVineyardRecordList(event.vineyardId);
        emit(VineyardRecordListSuccessState(vineyardRecordList));
      } on Exception catch (e) {
        emit(VineyardRecordFailureState(e.toString()));
      }
    });
  }
}
