import 'package:equatable/equatable.dart';

import '../../models/models.dart';

abstract class MqttEvent extends Equatable {
  const MqttEvent();

  @override
  List<Object> get props => [];
}

class MqttConnection extends MqttEvent {
  final Broker broker;

  const MqttConnection({this.broker});

  @override
  List<Object> get props => [broker];
}

class MqttDisconnection extends MqttEvent {
  final Broker broker;

  const MqttDisconnection({this.broker});

  @override
  List<Object> get props => [broker];
}

class MqttSubscription extends MqttEvent {
  final Topic topic;

  const MqttSubscription({this.topic});

  @override
  List<Object> get props => [topic];
}

class MqttUnsubscription extends MqttEvent {
  final Topic topic;

  const MqttUnsubscription({this.topic});

  @override
  List<Object> get props => [topic];
}
