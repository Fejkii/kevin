// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'vineyard_wine_bloc.dart';

abstract class VineyardWineEvent extends Equatable {
  const VineyardWineEvent();

  @override
  List<Object> get props => [];
}

class CreateVineyardWineEvent extends VineyardWineEvent {
  final String vineyardId;
  final VineyardWineModel vineyardWineModel;

  const CreateVineyardWineEvent(
    this.vineyardId,
    this.vineyardWineModel,
  );
}

class UpdateVineyardWineEvent extends VineyardWineEvent {
  final String vineyardId;
  final VineyardWineModel vineyardWineModel;

  const UpdateVineyardWineEvent(
    this.vineyardId,
    this.vineyardWineModel,
  );
}

class VineyardWineListEvent extends VineyardWineEvent {
  final String vineyardId;
  const VineyardWineListEvent({
    required this.vineyardId,
  });
}

class VineyardWineSummaryEvent extends VineyardWineEvent {
  final String vineyardId;
  const VineyardWineSummaryEvent({
    required this.vineyardId,
  });
}
