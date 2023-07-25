import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'wine_event.dart';
part 'wine_state.dart';

class WineBloc extends Bloc<WineEvent, WineState> {
  WineBloc() : super(WineLoadingState()) {
    on<WineEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
