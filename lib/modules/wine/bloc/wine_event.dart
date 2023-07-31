part of 'wine_bloc.dart';

abstract class WineEvent extends Equatable {
  const WineEvent();

  @override
  List<Object> get props => [];
}

class CreateWineEvent extends WineEvent {
  final String title;
  final List<WineVarietyModel> wineVarieties;
  final WineClassificationModel? wineClassification;
  final double quantity;
  final int year;
  final double? alcohol;
  final double? acid;
  final double? sugar;
  final String? note;
  const CreateWineEvent(
    this.title,
    this.wineVarieties,
    this.wineClassification,
    this.quantity,
    this.year,
    this.alcohol,
    this.acid,
    this.sugar,
    this.note,
  );

  @override
  List<Object> get props => [];
}

class UpdateWineEvent extends WineEvent {
  final WineModel wineModel;
  const UpdateWineEvent({
    required this.wineModel,
  });

  @override
  List<Object> get props => [wineModel];
}

class WineListRequestEvent extends WineEvent {}

class WineListReceivedEvent extends WineEvent {
  final List<WineModel> winelist;

  const WineListReceivedEvent(this.winelist);
}
