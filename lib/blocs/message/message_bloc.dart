import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/models.dart';
import '../blocs.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MqttBloc _mqttBloc;
  StreamSubscription _mqttState;
  StreamSubscription _messageReceived;

  MessageBloc(this._mqttBloc) : super(NoBrokerConnected()) {
    _mqttState = _mqttBloc.stream.listen((state) {
      if (state is MqttConnected) {
        add(BrokerConnected());
      } else if (state is MqttDisconnected) {
        add(BrokerDisconnected());
      }
    });
  }

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if (event is BrokerConnected) {
      yield* _mapMessageReceivedToState();
    } else if (event is BrokerMessageReceived) {
      yield* _mapMessageAddedToState(event);
    } else if (event is BrokerMessageSended) {
      yield* _mapMessageSendedToState(event);
    } else if (event is BrokerMessagesCleared) {
      yield* _mapMessagesClearedToState();
    } else if (event is BrokerDisconnected) {
      yield NoBrokerConnected();
    }
  }

  Stream<MessageState> _mapMessageReceivedToState() async* {
    yield MessagesReceptionSuccess([]);
    // await _messageReceived.cancel(); // null safety
    _messageReceived =
        _mqttBloc.mqttRepository.streamMessages().stream.listen((message) {
      add(BrokerMessageReceived(message));
    });
  }

  Stream<MessageState> _mapMessageAddedToState(
      BrokerMessageReceived event) async* {
    List<Message> messages =
        List.from((state as MessagesReceptionSuccess).messages)
          ..add(event.message);
    yield MessagesReceptionSuccess(messages);
  }

  Stream<MessageState> _mapMessageSendedToState(
      BrokerMessageSended event) async* {
    _mqttBloc.mqttRepository.publishMessage(event.message);
  }

  Stream<MessageState> _mapMessagesClearedToState() async* {
    yield MessagesReceptionSuccess([]);
  }

  @override
  Future<void> close() {
    _mqttState.cancel();
    _messageReceived.cancel();
    return super.close();
  }
}
