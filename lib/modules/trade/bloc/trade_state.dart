part of 'trade_bloc.dart';

abstract class TradeState extends Equatable {
  const TradeState();

  @override
  List<Object> get props => [];
}

class PurchaseInitial extends TradeState {}

class TradeLoadingState extends TradeState {}

class TradeSuccessState extends TradeState {}

class TradeListSuccessState extends TradeState {
  final List<TradeModel> purchaseList;
  const TradeListSuccessState(this.purchaseList);

  @override
  List<Object> get props => [purchaseList];
}

class TradeFailureState extends TradeState {
  final String errorMessage;
  const TradeFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
