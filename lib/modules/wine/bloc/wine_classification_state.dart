part of 'wine_classification_bloc.dart';

abstract class WineClassificationState extends Equatable {
  const WineClassificationState();
  
  @override
  List<Object> get props => [];
}

class WineClassificationInitial extends WineClassificationState {}

class WineClassificationLoadingState extends WineClassificationState {}

class WineClassificationListSuccessState extends WineClassificationState {
  final List<WineClassificationModel> wineClassificationList;
  const WineClassificationListSuccessState(this.wineClassificationList);

  @override
  List<Object> get props => [wineClassificationList];
}

class WineClassificationFailureState extends WineClassificationState {
  final String errorMessage;
  const WineClassificationFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}