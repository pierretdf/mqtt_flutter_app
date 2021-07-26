import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../settings/keys.dart';
import '../../views/views.dart';
import '../widgets.dart';

class BrokersView extends StatelessWidget {
  const BrokersView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        key: AppKeys.addBrokerFab,
        label: Text('Broker',
            style: TextStyle(color: Theme.of(context).primaryColor)),
        icon: Icon(Icons.add, color: Theme.of(context).primaryColor),
        onPressed: () {
          Navigator.pushNamed(context, '/add_broker');
        },
      ),
      body: BlocBuilder<BrokerBloc, BrokerState>(
        builder: (context, brokerState) {
          if (brokerState is BrokerLoadInProgress) {
            return const LoadingIndicator();
          } else if (brokerState is BrokerLoadSuccess) {
            return brokerState.brokers.isNotEmpty
                ? ListView.builder(
                    itemCount: brokerState.brokers.length,
                    itemBuilder: (context, index) {
                      final broker = brokerState.brokers[index];
                      return BrokerItem(
                          broker: broker,
                          onTapDetails: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                                return BrokerDetailsScreen(id: broker.id);
                              }),
                            );
                          },
                          onTapMqtt: () async {
                            if (context.read<MqttBloc>().state is MqttIdle) {
                              context
                                  .read<MqttBloc>()
                                  .add(MqttConnected(broker: broker));
                            } else if (context.read<MqttBloc>().state
                                is MqttDisconnectionSuccess) {
                              context
                                  .read<MqttBloc>()
                                  .add(MqttConnected(broker: broker));
                            } else if (context.read<MqttBloc>().state
                                is MqttConnectionSuccess) {
                              context
                                  .read<MqttBloc>()
                                  .add(MqttDisconnected(broker: broker));
                            }
                          },
                          onPressedDelete: () {
                            context
                                .read<BrokerBloc>()
                                .add(BrokerDeleted(broker));
                            Navigator.of(context).pop();
                          });
                    },
                  )
                : _noBrokerMessage();
          } else if (brokerState is BrokerLoadFailure) {
            return Center(
              child: Text('Error occured: ${brokerState.error}'),
            );
          } else {
            return const Center(
              child: Text('Oups, this is not supposed to happen'),
            );
          }
        },
      ),
    );
  }

  Widget _noBrokerMessage() {
    return const Center(
      child: Text(
        'Start adding a broker...',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
