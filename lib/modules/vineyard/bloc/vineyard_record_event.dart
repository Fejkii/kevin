part of 'vineyard_record_bloc.dart';

abstract class VineyardRecordEvent extends Equatable {
  const VineyardRecordEvent();

  @override
  List<Object> get props => [];
}

class CreateVineyardRecordEvent extends VineyardRecordEvent {
  final String vineyardId;
  final VineyardRecordModel vineyardRecordModel;

  const CreateVineyardRecordEvent(
    this.vineyardId,
    this.vineyardRecordModel,
  );
}

class UpdateVineyardRecordEvent extends VineyardRecordEvent {
  final String vineyardId;
  final VineyardRecordModel vineyardRecordModel;

  const UpdateVineyardRecordEvent(
    this.vineyardId,
    this.vineyardRecordModel,
  );
}

class VineyardRecordListEvent extends VineyardRecordEvent {
  final String vineyardId;
  const VineyardRecordListEvent({
    required this.vineyardId,
  });
}
