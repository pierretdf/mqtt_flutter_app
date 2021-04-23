import 'package:equatable/equatable.dart';

import '../../models/models.dart';

abstract class BrokerState extends Equatable {
  const BrokerState();

  @override
  List<Object> get props => [];
}

class BrokerLoadInProgress extends BrokerState {}

class BrokerLoadSuccess extends BrokerState {
  final List<Broker> brokers;
  //const BrokerLoadSuccess(this.brokers);

  const BrokerLoadSuccess([this.brokers = const []]);

  @override
  List<Object> get props => [brokers];
}

class BrokerLoadFailure extends BrokerState {
  final Error error;
  BrokerLoadFailure({this.error});
}
