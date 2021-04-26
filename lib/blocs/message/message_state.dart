import 'package:equatable/equatable.dart';

import '../../models/models.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

class BrokerConnectionFailed extends MessageState {}

class MessagesReceptionSuccess extends MessageState {
  final List<Message> messages;

  const MessagesReceptionSuccess(this.messages);

  @override
  List<Object> get props => [messages];
}

class MessagesReceptionFailure extends MessageState {
  final Error error;
  const MessagesReceptionFailure(this.error);
}
