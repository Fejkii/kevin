part of 'vineyard_wine_bloc.dart';

abstract class VineyardWineState extends Equatable {
  const VineyardWineState();

  @override
  List<Object> get props => [];
}

class VineyardWineInitial extends VineyardWineState {}

class VineyardWineLoadingState extends VineyardWineState {}

class VineyardWineSuccessState extends VineyardWineState {}

class VineyardWineListSuccessState extends VineyardWineState {
  final List<VineyardWineModel> vineyardWineList;
  const VineyardWineListSuccessState({
    required this.vineyardWineList,
  });

  @override
  List<Object> get props => [vineyardWineList];
}

class VineyardWineSummarySuccessState extends VineyardWineState {
  final VineyardWineSummaryModel vineyardWineSummaryModel;
  const VineyardWineSummarySuccessState({
    required this.vineyardWineSummaryModel,
  });

  @override
  List<Object> get props => [vineyardWineSummaryModel];
}

class VineyardWineFailureState extends VineyardWineState {
  final String errorMessage;
  const VineyardWineFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
