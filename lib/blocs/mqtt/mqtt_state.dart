import 'package:equatable/equatable.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../../models/models.dart';

abstract class MqttState extends Equatable {
  const MqttState();

  @override
  List<Object> get props => [];
}

class MqttIdle extends MqttState {}

class MqttDisconnectionSuccess extends MqttState {
  final Broker broker;

  const MqttDisconnectionSuccess(this.broker);

  @override
  List<Object> get props => [broker];
}

class MqttConnectionInProgress extends MqttState {
  //final MqttServerClient mqttClient;
  final Broker broker;

  const MqttConnectionInProgress(this.broker);

  @override
  List<Object> get props => [broker];
}

class MqttConnectionSuccess extends MqttState {
  //final MqttServerClient mqttClient;
  final Broker broker;

  const MqttConnectionSuccess(this.broker);

  @override
  List<Object> get props => [broker];
}

class MqttConnectionFailure extends MqttState {
  final Broker broker;
  //final Error error;

  const MqttConnectionFailure(this.broker);

  @override
  List<Object> get props => [broker];
}
