part of 'wine_bloc.dart';

abstract class WineState extends Equatable {
  const WineState();

  @override
  List<Object> get props => [];
}

class WineLoadingState extends WineState {}
