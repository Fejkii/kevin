import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'wine_event.dart';
part 'wine_state.dart';

class WineBloc extends Bloc<WineEvent, WineState> {
  WineBloc() : super(WineInitial()) {
    on<WineEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
