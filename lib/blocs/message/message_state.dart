import 'package:equatable/equatable.dart';

import '../../models/models.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

class NoBrokerConnected extends MessageState {}

class MessagesReceptionSuccess extends MessageState {
  final List<Message> messages;

  const MessagesReceptionSuccess(this.messages);

  @override
  List<Object> get props => [messages];
}

class MessagesFailure extends MessageState {
  final Error error;
  MessagesFailure(this.error);
}
