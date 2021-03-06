import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/models.dart';
import '../../services/broker_repository.dart';
import '../blocs.dart';

class BrokerBloc extends Bloc<BrokerEvent, BrokerState> {
  final BrokerRepository brokerRepository;
  final MqttBloc mqttBloc;
  StreamSubscription _mqttConnection;

  BrokerBloc(this.brokerRepository, this.mqttBloc)
      : super(BrokerLoadInProgress()) {
    _mqttConnection = mqttBloc.stream.listen((state) {
      if (state is MqttConnectionInProgress) {
        add(BrokerUpdated((mqttBloc.state as MqttConnectionInProgress)
            .broker
            .copyWith(state: 'connecting')));
      } else if (state is MqttConnectionSuccess) {
        add(BrokerUpdated((mqttBloc.state as MqttConnectionSuccess)
            .broker
            .copyWith(state: 'connected')));
      } else if (state is MqttDisconnectionSuccess) {
        add(BrokerUpdated((mqttBloc.state as MqttDisconnectionSuccess)
            .broker
            .copyWith(state: 'disconnected')));
      } else if (state is MqttConnectionFailure) {
        add(BrokerUpdated((mqttBloc.state as MqttConnectionFailure)
            .broker
            .copyWith(state: 'failed')));
      }
    });
  }

  @override
  Stream<BrokerState> mapEventToState(BrokerEvent event) async* {
    if (event is BrokersLoaded) {
      yield* _mapBrokersLoadedToState();
    } else if (event is BrokerAdded) {
      yield* _mapBrokerAddedToState(event);
    } else if (event is BrokerUpdated) {
      yield* _mapBrokerUpdatedToState(event);
    } else if (event is BrokerDeleted) {
      yield* _mapBrokerDeletedToState(event);
    }
  }

  Stream<BrokerState> _mapBrokersLoadedToState() async* {
    try {
      await brokerRepository.updateBrokerStateToDisconnected();
      final brokers = await brokerRepository.getBrokers();
      yield BrokerLoadSuccess(brokers);
    } catch (e) {
      yield BrokerLoadFailure(e);
    }
  }

  Stream<BrokerState> _mapBrokerAddedToState(BrokerAdded event) async* {
    if (state is BrokerLoadSuccess) {
      await brokerRepository.addBroker(event.broker);
      // final updatedBrokers =
      //     List<Broker>.from((state as BrokerLoadSuccess).brokers)
      //       ..add(event.broker);
      yield BrokerLoadSuccess(await brokerRepository.getBrokers());
    }
  }

  Stream<BrokerState> _mapBrokerUpdatedToState(BrokerUpdated event) async* {
    if (state is BrokerLoadSuccess) {
      final updatedBrokers = (state as BrokerLoadSuccess).brokers.map((broker) {
        return broker.id == event.broker.id ? event.broker : broker;
      }).toList();
      yield BrokerLoadSuccess(updatedBrokers);
      await brokerRepository.updateBroker(event.broker);
    }
  }

  Stream<BrokerState> _mapBrokerDeletedToState(BrokerDeleted event) async* {
    if (state is BrokerLoadSuccess) {
      final updatedBrokers = (state as BrokerLoadSuccess)
          .brokers
          .where((broker) => broker.id != event.broker.id)
          .toList();
      // Disconnect MQTT broker if connected
      if (event.broker.state == 'connected') {
        mqttBloc.mqttRepository.disconnectClient();
      }
      yield BrokerLoadSuccess(updatedBrokers);
      await brokerRepository.deleteBroker(event.broker.id);
    }
  }

  @override
  Future<void> close() {
    _mqttConnection.cancel();
    return super.close();
  }
}
