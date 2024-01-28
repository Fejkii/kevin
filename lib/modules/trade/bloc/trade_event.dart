part of 'trade_bloc.dart';

abstract class TradeEvent extends Equatable {
  const TradeEvent();

  @override
  List<Object> get props => [];
}

class CreateTradeEvent extends TradeEvent {
  final TradeModel tradeModel;
  const CreateTradeEvent({
    required this.tradeModel,
  });

  @override
  List<Object> get props => [tradeModel];
}

class UpdateTradeEvent extends TradeEvent {
  final TradeModel tradeModel;
  const UpdateTradeEvent({
    required this.tradeModel,
  });

  @override
  List<Object> get props => [tradeModel];
}

class GetTradeListEvent extends TradeEvent {
  final TradeType tradeType;

  const GetTradeListEvent(this.tradeType);

  @override
  List<Object> get props => [tradeType];
}
