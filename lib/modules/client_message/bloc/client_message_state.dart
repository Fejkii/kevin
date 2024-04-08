part of 'client_message_bloc.dart';

sealed class ClientMessageState extends Equatable {
  const ClientMessageState();

  @override
  List<Object> get props => [];
}

final class ClientMessageInitial extends ClientMessageState {}

final class ClientMessageLodadingState extends ClientMessageState {}

final class ClientMessageSendedState extends ClientMessageState {}

final class ClientMessageFailureState extends ClientMessageState {
  final String errorMessage;
  const ClientMessageFailureState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
