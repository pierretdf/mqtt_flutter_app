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
    if (event is MqttStateToggling) {
      if (state is MqttIdle || state is MqttDisconnectionSuccess) {
        yield* _mapMqttConnectedToState(event);
      } else if (state is MqttConnectionSuccess) {
        yield* _mapMqttDisconnectedToState(event);
      }
    }
    // if (event is MqttConnected) {
    //   yield* _mapMqttConnectedToState(event);
    // } else if (event is MqttDisconnected) {
    //   yield* _mapMqttDisconnectedToState(event);
    // }
  }

  Stream<MqttState> _mapMqttConnectedToState(MqttStateToggling event) async* {
    /**
     * TODO : any broker is connected ?
     *  if true
     *    Disconnect this broker
     *  else
     *    
     */
    final mqttClient = await mqttRepository.prepareMqttClient(event.broker);
    if (mqttClient.connectionStatus?.state == MqttConnectionState.connected) {
      final topics = await topicRepository.getTopics();
      topics.forEach((topic) {
        mqttRepository.subscribeToTopic(topic.title);
      });
      yield MqttConnectionSuccess(event.broker);
    } else if (mqttClient.connectionStatus?.state ==
        MqttConnectionState.faulted) {
      yield MqttConnectionFailure(event.broker);
    }
    // try {
    //   final mqttClient = await mqttRepository.prepareMqttClient(event.broker);
    //   if (mqttClient.connectionStatus.state == MqttConnectionState.connected) {
    //     final topics = await topicRepository.getTopics();
    //     topics.forEach((topic) {
    //       mqttRepository.subscribeToTopic(topic.title);
    //     });
    //     yield MqttConnectionSuccess(event.broker);
    //   }
    // } catch (error) {
    //   debugPrint('MQTT connection failed');
    //   yield MqttConnectionFailure(error, event.broker);
    // }
  }

  Stream<MqttState> _mapMqttDisconnectedToState(
      MqttStateToggling event) async* {
    mqttRepository.disconnectClient();
    yield MqttDisconnectionSuccess(event.broker);
  }
}
