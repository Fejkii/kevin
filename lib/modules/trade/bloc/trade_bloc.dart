import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/modules/trade/data/model/trade_model.dart';
import 'package:kevin/modules/trade/data/repository/trade_repository.dart';

part 'trade_event.dart';
part 'trade_state.dart';

class TradeBloc extends Bloc<TradeEvent, TradeState> {
  final TradeRepository tradeRepository = TradeRepository();

  TradeBloc() : super(PurchaseInitial()) {
    on<CreateTradeEvent>((event, emit) async {
      emit(TradeLoadingState());
      try {
        await tradeRepository.createTrade(event.tradeModel);
        emit(TradeSuccessState());
      } on Exception catch (e) {
        emit(TradeFailureState(e.toString()));
      }
    });

    on<UpdateTradeEvent>((event, emit) async {
      emit(TradeLoadingState());
      try {
        await tradeRepository.updateTrade(event.tradeModel);
        emit(TradeSuccessState());
      } on Exception catch (e) {
        emit(TradeFailureState(e.toString()));
      }
    });

    on<GetTradeListEvent>((event, emit) async {
      emit(TradeLoadingState());
      try {
        final list = await tradeRepository.getTradeList(event.tradeType);
        emit(TradeListSuccessState(list));
      } on Exception catch (e) {
        emit(TradeFailureState(e.toString()));
      }
    });
  }
}
