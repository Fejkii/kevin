part of 'wine_record_bloc.dart';

abstract class WineRecordEvent extends Equatable {
  const WineRecordEvent();

  @override
  List<Object> get props => [];
}

class CreateWineRecordEvent extends WineRecordEvent {
  final String wineId;
  final WineRecordModel wineRecordModel;
  const CreateWineRecordEvent(
    this.wineId,
    this.wineRecordModel,
  );

  @override
  List<Object> get props => [wineId, wineRecordModel];
}

class UpdateWineRecordEvent extends WineRecordEvent {
  final String wineId;
  final WineRecordModel wineRecordModel;
  const UpdateWineRecordEvent({
    required this.wineId,
    required this.wineRecordModel,
  });

  @override
  List<Object> get props => [wineId, wineRecordModel];
}

class WineRecordListEvent extends WineRecordEvent {
  final String wineId;

  const WineRecordListEvent(this.wineId);
  @override
  List<Object> get props => [wineId];
}
