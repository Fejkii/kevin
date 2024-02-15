part of 'wine_bloc.dart';

abstract class WineState extends Equatable {
  const WineState();

  @override
  List<Object> get props => [];
}

class WineInitial extends WineState {}

class WineLoadingState extends WineState {}

class WineLoadSuccessState extends WineState {}

class WineSaveSuccessState extends WineState {}

class WineListSuccessState extends WineState {
  final List<WineModel> wineList;
  const WineListSuccessState(this.wineList);

  @override
  List<Object> get props => [wineList];
}

class WineFailureState extends WineState {
  final String errorMessage;
  const WineFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
