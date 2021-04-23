import 'package:equatable/equatable.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../../models/models.dart';

abstract class MqttState extends Equatable {
  const MqttState();

  @override
  List<Object> get props => [];
}

class MqttIdle extends MqttState {}

class MqttDisconnected extends MqttState {
  final Broker broker;

  const MqttDisconnected(this.broker);

  @override
  List<Object> get props => [broker];
}

class MqttConnecting extends MqttState {
  final Broker broker;

  const MqttConnecting(this.broker);

  @override
  List<Object> get props => [broker];
}

class MqttConnected extends MqttState {
  final MqttServerClient mqttClient;
  final Broker broker;

  const MqttConnected(this.broker, this.mqttClient);

  @override
  List<Object> get props => [broker];
}

class MqttConnectedSubscribed extends MqttState {
  // final List<Topic> topics;

  // const MqttConnectedSubscribed(this.topics);

  // @override
  // List<Object> get props => [topics];
}

class MqttConnectedUnsubscribed extends MqttState {
  // final Broker broker;

  // const MqttConnectedUnsubscribed(this.broker);

  // @override
  // List<Object> get props => [broker];
}

class MqttConnectionFailure extends MqttState {
  final Broker broker;
  final Error error;

  @override
  List<Object> get props => [];

  MqttConnectionFailure(this.error, this.broker);
}
