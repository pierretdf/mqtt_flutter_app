import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../settings/keys.dart';
import '../../settings/localization.dart';
import '../../views/views.dart';
import '../widgets.dart';

class BrokersView extends StatelessWidget {
  BrokersView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = FlutterBlocLocalizations.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor:
            Theme.of(context).floatingActionButtonTheme.backgroundColor,
        label: Text('Broker',
            style: TextStyle(color: Theme.of(context).accentColor)),
        icon: Icon(Icons.add, color: Theme.of(context).accentColor),
        onPressed: () {
          Navigator.pushNamed(context, '/add_broker');
        },
      ),
      body: BlocBuilder<BrokerBloc, BrokerState>(
        builder: (context, brokerState) {
          if (brokerState is BrokerLoadInProgress) {
            return LoadingIndicator();
          } else if (brokerState is BrokerLoadSuccess) {
            return brokerState.brokers.length != 0
                ? ListView.builder(
                    itemCount: brokerState.brokers.length,
                    itemBuilder: (context, index) {
                      final broker = brokerState.brokers[index];
                      return BrokerItem(
                        broker: broker,
                        onDismissed: (direction) {
                          context.read<BrokerBloc>().add(BrokerDeleted(broker));
                          ScaffoldMessenger.of(context).showSnackBar(
                            DeleteBrokerSnackBar(
                              key: ArchSampleKeys.snackbar,
                              broker: broker,
                              onUndo: () => context
                                  .read<BrokerBloc>()
                                  .add(BrokerAdded(broker)),
                              localizations: localizations,
                            ),
                          );
                        },
                        onTapDetails: () async {
                          final removedBroker =
                              await Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return BrokerDetailsScreen(id: broker.id);
                            }),
                          );
                          if (removedBroker != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              DeleteBrokerSnackBar(
                                //key: ArchSampleKeys.snackbar,
                                broker: broker,
                                onUndo: () => context
                                    .read<BrokerBloc>()
                                    .add(BrokerAdded(broker)),
                                localizations: localizations,
                              ),
                            );
                          }
                        },
                        onTapMqtt: () async {
                          if (context.read<MqttBloc>().state is MqttIdle) {
                            context
                                .read<MqttBloc>()
                                .add(MqttConnection(broker: broker));
                          } else if (context.read<MqttBloc>().state
                              is MqttDisconnected) {
                            context
                                .read<MqttBloc>()
                                .add(MqttConnection(broker: broker));
                          } else if (context.read<MqttBloc>().state
                              is MqttConnected) {
                            context
                                .read<MqttBloc>()
                                .add(MqttDisconnection(broker: broker));
                            // context.read<BrokerBloc>().add(BrokerUpdated(
                            //     broker.copyWith(state: 'disconnected')));
                          }
                        },
                      );
                    },
                  )
                : _noBrokerMessage();
          } else if (brokerState is BrokerLoadFailure) {
            return Center(
              child: Text('Error occured: ${brokerState.error}'),
            );
          } else {
            return Center(
              child: Text('Oups, this is not supposed to happen'),
            );
          }
        },
      ),
    );
  }

  Widget _noBrokerMessage() {
    return Center(
      child: Text(
        "Start adding a broker...",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
