import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kevin/modules/client_message/data/client_message_model.dart';
import 'package:kevin/modules/client_message/data/client_message_repository.dart';
import 'package:kevin/services/app_preferences.dart';
import 'package:kevin/services/dependency_injection.dart';

part 'client_message_event.dart';
part 'client_message_state.dart';

class ClientMessageBloc extends Bloc<ClientMessageEvent, ClientMessageState> {
  ClientMessageBloc() : super(ClientMessageInitial()) {
    final ClientMessageRepository clientMessageRepository = ClientMessageRepository();
    final AppPreferences appPreferences = instance<AppPreferences>();

    on<CreateClientMessageEvent>((event, emit) async {
      emit(ClientMessageLodadingState());
      
      try {
        ClientMessageModel clientMessageModel = ClientMessageModel(
          null,
          appPreferences.getUser(),
          event.title,
          event.message,
          DateTime.now(),
        );

        await clientMessageRepository.createMessage(clientMessageModel);

        emit(ClientMessageSendedState());
      } on Exception catch (e) {
        emit(ClientMessageFailureState(e.toString()));
      }
    });
  }
}
