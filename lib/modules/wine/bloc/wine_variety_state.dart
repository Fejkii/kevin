part of 'wine_variety_bloc.dart';

abstract class WineVarietyState extends Equatable {
  const WineVarietyState();

  @override
  List<Object> get props => [];
}

class WineVarietyInitial extends WineVarietyState {}

class WineVarietyLoadingState extends WineVarietyState {}

class WineVarietySuccessState extends WineVarietyState {}

class WineVarietyListSuccessState extends WineVarietyState {
  final List<WineVarietyModel> wineVarietyList;
  const WineVarietyListSuccessState(this.wineVarietyList);

  @override
  List<Object> get props => [wineVarietyList];
}

class WineVarietyFailureState extends WineVarietyState {
  final String errorMessage;
  const WineVarietyFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
