part of 'client_message_bloc.dart';

sealed class ClientMessageEvent extends Equatable {
  const ClientMessageEvent();

  @override
  List<Object> get props => [];
}

class CreateClientMessageEvent extends ClientMessageEvent {
  final String title;
  final String message;
  const CreateClientMessageEvent({
    required this.title,
    required this.message,
  });

  @override
  List<Object> get props => [title];
}