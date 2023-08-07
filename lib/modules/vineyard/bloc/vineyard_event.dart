part of 'vineyard_bloc.dart';

abstract class VineyardEvent extends Equatable {
  const VineyardEvent();

  @override
  List<Object> get props => [];
}

class CreateVineyardEvent extends VineyardEvent {
  final VineyardModel vineyardModel;

  const CreateVineyardEvent(this.vineyardModel);
}

class UpdateVineyardEvent extends VineyardEvent {
  final VineyardModel vineyardModel;

  const UpdateVineyardEvent(this.vineyardModel);
}

class GetVineyardEvent extends VineyardEvent {
  final String vineyardId;

  const GetVineyardEvent(this.vineyardId);
}

class VineyardListEvent extends VineyardEvent {}
