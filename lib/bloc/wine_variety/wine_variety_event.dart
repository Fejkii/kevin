part of 'wine_variety_bloc.dart';

abstract class WineVarietyEvent extends Equatable {
  const WineVarietyEvent();

  @override
  List<Object> get props => [];
}

class CreateWineVarietyEvent extends WineVarietyEvent {
  final String title;
  final String code;
  const CreateWineVarietyEvent({
    required this.title,
    required this.code,
  });

  @override
  List<Object> get props => [title, code];
}

class UpdateWineVarietyEvent extends WineVarietyEvent {
  final WineVarietyModel wineVarietyModel;
  const UpdateWineVarietyEvent({
    required this.wineVarietyModel,
  });

  @override
  List<Object> get props => [wineVarietyModel];
}

class WineVarietyListEvent extends WineVarietyEvent {}
