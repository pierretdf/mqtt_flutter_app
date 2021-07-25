import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import '../../services/repositories.dart';
import '../blocs.dart';

class MqttBloc extends Bloc<MqttEvent, MqttState> {
  final MqttRepository mqttRepository;
  final TopicRepository topicRepository;

  MqttBloc(this.mqttRepository, this.topicRepository) : super(MqttIdle());

  @override
  Stream<MqttState> mapEventToState(MqttEvent event) async* {
    if (event is MqttConnected) {
      yield* _mapMqttConnectedToState(event);
    } else if (event is MqttDisconnected) {
      yield* _mapMqttDisconnectedToState(event);
    }
  }

  Stream<MqttState> _mapMqttConnectedToState(MqttConnected event) async* {
    try {
      final mqttClient = await mqttRepository.prepareMqttClient(event.broker);
      if (mqttClient.connectionStatus.state == MqttConnectionState.connected) {
        final topics = await topicRepository.getTopics();
        topics.forEach((topic) {
          mqttRepository.subscribeToTopic(topic.title);
        });
        yield MqttConnectionSuccess(event.broker, mqttClient);
      }
    } catch (error) {
      yield MqttConnectionFailure(error, event.broker);
    }
  }

  Stream<MqttState> _mapMqttDisconnectedToState(MqttDisconnected event) async* {
    if (state is MqttConnectionSuccess) {
      mqttRepository.disconnectClient();
      yield MqttDisconnectionSuccess(event.broker);
    }
  }
}
