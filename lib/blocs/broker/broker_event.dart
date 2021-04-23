import 'package:equatable/equatable.dart';

import '../../models/models.dart';

abstract class BrokerEvent extends Equatable {
  const BrokerEvent();

  @override
  List<Object> get props => [];
}

class BrokersLoaded extends BrokerEvent {}

class BrokerAdded extends BrokerEvent {
  final Broker broker;

  const BrokerAdded(this.broker);

  @override
  List<Object> get props => [broker];

  @override
  String toString() => 'BrokerAdded { broker: $broker }';
}

class BrokerUpdated extends BrokerEvent {
  final Broker broker;

  const BrokerUpdated(this.broker);

  @override
  List<Object> get props => [broker];

  @override
  String toString() => 'BrokerUpdated { updatedBroker: $broker }';
}

class BrokerDeleted extends BrokerEvent {
  final Broker broker;

  const BrokerDeleted(this.broker);

  @override
  List<Object> get props => [broker];

  @override
  String toString() => 'BrokerDeleted { broker: $broker }';
}

class ClearCompleted extends BrokerEvent {}
