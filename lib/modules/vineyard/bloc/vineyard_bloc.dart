import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/modules/vineyard/model/vineyard_model.dart';
import 'package:kevin/modules/vineyard/repository/vineyard_repository.dart';

part 'vineyard_event.dart';
part 'vineyard_state.dart';

class VineyardBloc extends Bloc<VineyardEvent, VineyardState> {
  final VineyardRepository wineRepository = VineyardRepository();

  VineyardBloc() : super(VineyardInitial()) {
    on<CreateVineyardEvent>((event, emit) async {
      emit(VineyardLoadingState());
      try {
        await wineRepository.createVineyard(event.vineyardModel);
        emit(VineyardSuccessState());
      } on Exception catch (e) {
        emit(VineyardFailureState(e.toString()));
      }
    });

    on<UpdateVineyardEvent>((event, emit) async {
      emit(VineyardLoadingState());
      try {
        await wineRepository.updateVineyard(event.vineyardModel);
        emit(VineyardSuccessState());
      } on Exception catch (e) {
        emit(VineyardFailureState(e.toString()));
      }
    });

    on<GetVineyardEvent>((event, emit) async {
      emit(VineyardLoadingState());
      try {
        await wineRepository.getVineyard(event.vineyardId);
        emit(VineyardSuccessState());
      } on Exception catch (e) {
        emit(VineyardFailureState(e.toString()));
      }
    });

    on<VineyardListEvent>((event, emit) async {
      emit(VineyardLoadingState());
      try {
        List<VineyardModel> vineyardList = await wineRepository.getVineyarList();
        emit(VineyardListSuccessState(vineyardList: vineyardList));
      } on Exception catch (e) {
        emit(VineyardFailureState(e.toString()));
      }
    });
  }
}
