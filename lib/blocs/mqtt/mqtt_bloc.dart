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
    if (event is MqttConnection) {
      yield* _mapMqttConnectionToState(event);
    } else if (event is MqttDisconnection) {
      yield* _mapMqttDisconnectionToState(event);
    } else if (event is MqttSubscription) {
      yield* _mapMqttSubscriptionToState(event);
    } else if (event is MqttUnsubscription) {
      yield* _mapMqttUnsubscriptionToState(event);
    }
  }

  Stream<MqttState> _mapMqttConnectionToState(MqttConnection event) async* {
    try {
      final mqttClient = await mqttRepository.prepareMqttClient(event.broker);
      yield MqttConnecting(event.broker);
      if (mqttClient.connectionStatus.state == MqttConnectionState.connected) {
        // TODO every topics of broker which has been connected (brokerId depedent)
        final topics = await topicRepository.getTopics(); //event.broker.id
        topics.forEach((topic) {
          mqttRepository.subscribeToTopic(topic.title);
        });
        yield MqttConnected(event.broker, mqttClient);
      }
    } catch (error) {
      yield MqttConnectionFailure(error, event.broker);
    }
  }

  Stream<MqttState> _mapMqttDisconnectionToState(
      MqttDisconnection event) async* {
    if (state is MqttConnected) {
      mqttRepository.disconnectClient();
      yield MqttDisconnected(event.broker);
    }
  }

  Stream<MqttState> _mapMqttSubscriptionToState(MqttSubscription event) async* {
    if (state is MqttConnected) {
      mqttRepository.subscribeToTopic(event.topic.title);
      yield MqttConnectedSubscribed();
    }
  }

  Stream<MqttState> _mapMqttUnsubscriptionToState(
      MqttUnsubscription event) async* {
    if (state is MqttConnected) {
      mqttRepository.unSubscribeFromTopic(event.topic.title);
      yield MqttConnectedUnsubscribed();
    }
  }

  // MqttState _mapMqttStateChangedToState(MqttStateChanged event) {
  //   MqttState brokerConnectionState;
  //   if (event.mqttState is MqttConnected) {
  //     brokerConnectionState = BrokerConnectionStateUI(
  //         icon: Icon(Icons.cloud_done_sharp, color: Colors.black, size: 30),
  //         color: Colors.green);
  //   } else if (event.mqttState is MqttConnecting) {
  //     brokerConnectionState = BrokerConnectionStateUI(
  //         icon: Icon(Icons.cloud_download_sharp, color: Colors.black, size: 30),
  //         color: Colors.orange);
  //   } else if (event.mqttState is MqttConnectedSubscribed) {
  //     brokerConnectionState = BrokerConnectionStateUI(
  //         icon: Icon(Icons.cloud_done_sharp, color: Colors.black, size: 30),
  //         color: Colors.green);
  //   } else if (event.mqttState is MqttConnectedUnsubscribed) {
  //     brokerConnectionState = BrokerConnectionStateUI(
  //         icon: Icon(Icons.cloud_done_sharp, color: Colors.black, size: 30),
  //         color: Colors.green);
  //   } else if (event.mqttState is MqttDisconnected) {
  //     brokerConnectionState = BrokerConnectionStateUI(
  //         icon: Icon(Icons.cloud_off_sharp, color: Colors.black, size: 30),
  //         color: Colors.red);
  //   } else if (event.mqttState is MqttConnectionFailure) {
  //     brokerConnectionState = BrokerConnectionStateUI(
  //         icon: Icon(Icons.cloud_off_sharp, color: Colors.black, size: 30),
  //         color: Colors.red);
  //   }
  //   return state;
  // }
}
