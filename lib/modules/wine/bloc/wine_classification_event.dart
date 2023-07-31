part of 'wine_classification_bloc.dart';

abstract class WineClassificationEvent extends Equatable {
  const WineClassificationEvent();

  @override
  List<Object> get props => [];
}

class WineClassificationListEvent extends WineClassificationEvent {}
