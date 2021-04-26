import 'package:equatable/equatable.dart';

import '../../models/models.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class BrokerConnected extends MessageEvent {}

class BrokerDisconnected extends MessageEvent {}

class BrokerMessageReceived extends MessageEvent {
  final Message message;

  const BrokerMessageReceived(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'MessageReceived { message: $message }';
}

class BrokerMessageSended extends MessageEvent {
  final Message message;

  const BrokerMessageSended(this.message);

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'MessageSended { message: $message }';
}

class BrokerMessagesCleared extends MessageEvent {}
