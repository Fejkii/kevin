part of 'vineyard_bloc.dart';

abstract class VineyardState extends Equatable {
  const VineyardState();

  @override
  List<Object> get props => [];
}

class VineyardInitial extends VineyardState {}

class VineyardLoadingState extends VineyardState {}

class VineyardSuccessState extends VineyardState {}

class VineyardListSuccessState extends VineyardState {
  final List<VineyardModel> vineyardList;
  const VineyardListSuccessState({
    required this.vineyardList,
  });

  @override
  List<Object> get props => [vineyardList];
}

class VineyardFailureState extends VineyardState {
  final String errorMessage;
  const VineyardFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
