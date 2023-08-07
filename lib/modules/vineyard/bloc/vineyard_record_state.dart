part of 'vineyard_record_bloc.dart';

abstract class VineyardRecordState extends Equatable {
  const VineyardRecordState();

  @override
  List<Object> get props => [];
}

class VineyardRecordInitial extends VineyardRecordState {}

class VineyardRecordLoadingState extends VineyardRecordState {}

class VineyardRecordSuccessState extends VineyardRecordState {}

class VineyardRecordListSuccessState extends VineyardRecordState {
  final List<VineyardRecordModel> vineyardRecordList;

  const VineyardRecordListSuccessState(this.vineyardRecordList);

  @override
  List<Object> get props => [vineyardRecordList];
}

class VineyardRecordFailureState extends VineyardRecordState {
  final String errorMessage;
  const VineyardRecordFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
