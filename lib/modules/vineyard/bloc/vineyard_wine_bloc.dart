import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/modules/vineyard/model/vineyard_wine_model.dart';
import 'package:kevin/modules/vineyard/model/vineyard_wine_summary_model.dart';
import 'package:kevin/modules/vineyard/repository/vineyard_wine_repository.dart';

part 'vineyard_wine_event.dart';
part 'vineyard_wine_state.dart';

class VineyardWineBloc extends Bloc<VineyardWineEvent, VineyardWineState> {
  VineyardWineRepository vineyardWineRepository = VineyardWineRepository();

  VineyardWineBloc() : super(VineyardWineInitial()) {
    on<CreateVineyardWineEvent>((event, emit) async {
      emit(VineyardWineLoadingState());
      try {
        await vineyardWineRepository.createVineyardWine(event.vineyardId, event.vineyardWineModel);
        emit(VineyardWineSuccessState());
      } on Exception catch (e) {
        emit(VineyardWineFailureState(e.toString()));
      }
    });

    on<UpdateVineyardWineEvent>((event, emit) async {
      emit(VineyardWineLoadingState());
      try {
        await vineyardWineRepository.updateVineyardWine(event.vineyardId, event.vineyardWineModel);
        emit(VineyardWineSuccessState());
      } on Exception catch (e) {
        emit(VineyardWineFailureState(e.toString()));
      }
    });

    on<VineyardWineListEvent>((event, emit) async {
      emit(VineyardWineLoadingState());
      try {
        List<VineyardWineModel> vineyardWineList = await vineyardWineRepository.getVineyardWineList(event.vineyardId);
        emit(VineyardWineListSuccessState(vineyardWineList: vineyardWineList));
      } on Exception catch (e) {
        emit(VineyardWineFailureState(e.toString()));
      }
    });

    on<VineyardWineSummaryEvent>((event, emit) async {
      emit(VineyardWineLoadingState());
      try {
        VineyardWineSummaryModel vineyardWineSummaryModel = await vineyardWineRepository.getVineyardWineSummary(event.vineyardId);
        emit(VineyardWineSummarySuccessState(vineyardWineSummaryModel: vineyardWineSummaryModel));
      } on Exception catch (e) {
        emit(VineyardWineFailureState(e.toString()));
      }
    });
  }
}
