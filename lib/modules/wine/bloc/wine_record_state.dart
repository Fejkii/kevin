part of 'wine_record_bloc.dart';

abstract class WineRecordState extends Equatable {
  const WineRecordState();

  @override
  List<Object> get props => [];
}

class WineRecordInitial extends WineRecordState {}

class WineRecordLoadingState extends WineRecordState {}

class WineRecordSuccessState extends WineRecordState {}

class WineRecordFailureState extends WineRecordState {
  final String errorMessage;
  const WineRecordFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class WineRecordListSuccessState extends WineRecordState {
  final List<WineRecordModel> wineRecordList;
  const WineRecordListSuccessState(this.wineRecordList);
}
