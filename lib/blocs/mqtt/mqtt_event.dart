import 'package:equatable/equatable.dart';

import '../../models/models.dart';

abstract class MqttEvent extends Equatable {
  const MqttEvent();

  @override
  List<Object> get props => [];
}

class MqttConnected extends MqttEvent {
  final Broker broker;

  const MqttConnected({this.broker});

  @override
  List<Object> get props => [broker];
}

class MqttDisconnected extends MqttEvent {
  final Broker broker;

  const MqttDisconnected({ this.broker});

  @override
  List<Object> get props => [broker];
}

class MqttStateToggling extends MqttEvent {
  final Broker broker;

  const MqttStateToggling({ this.broker});

  @override
  List<Object> get props => [broker];
}
