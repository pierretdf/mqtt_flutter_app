import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_flutter_bloc/settings/keys.dart';

import '../blocs/blocs.dart';
import '../settings/localization.dart';
import '../widgets/widgets.dart';
import 'add_edit_broker_view.dart';

class BrokerDetailsScreen extends StatelessWidget {
  final int id;

  const BrokerDetailsScreen({Key key, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = FlutterBlocLocalizations.of(context);

    return BlocBuilder<BrokerBloc, BrokerState>(
      builder: (context, state) {
        final broker = (state as BrokerLoadSuccess)
            .brokers
            .firstWhere((broker) => broker.id == id, orElse: () => null);
        return Scaffold(
          appBar: AppBar(
            title: Text(localizations.brokerDetails,
                style: TextStyle(color: Theme.of(context).primaryColorDark)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.red),
                key: AppKeys.deleteBrokerButton,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return FloatingBottomSheet(
                        title: 'Attention',
                        description:
                            'Are you sur to delete the ${broker.name} broker ?',
                        mainButtonTitle: 'Delete',
                        onPressed: () {
                          context.read<BrokerBloc>().add(BrokerDeleted(broker));
                          Navigator.of(context).pop();
                          // To quit the Broker Details Page
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                },
              )
            ],
          ),
          body: broker != null
              ? //key: FlutterTodosKeys.emptyDetailsContainer
              ListView(
                  padding: const EdgeInsets.all(25.0),
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        top: 16.0,
                        bottom: 25.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            broker.name,
                            key: AppKeys.detailsBrokerItemName,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: broker.state == 'connected'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Chip(
                          label: const Text(
                            'Broker address',
                            key: AppKeys.detailsBrokerItemAddress,
                          ),
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          broker.address,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      children: [
                        Chip(
                          label: const Text(
                            'Port',
                            key: AppKeys.detailsBrokerItemPort,
                          ),
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${broker.port}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    broker.identifier != null
                        ? Row(
                            children: [
                              Chip(
                                label: const Text(
                                  'Client ID',
                                  key: AppKeys.detailsBrokerItemIdentifier,
                                ),
                                labelStyle: TextStyle(
                                    color: Theme.of(context).accentColor),
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                broker.identifier,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ],
                          )
                        : Container(),
                    const SizedBox(height: 5.0),
                    broker.username != null
                        ? Row(
                            children: [
                              Chip(
                                label: const Text(
                                  'Username',
                                  key: AppKeys.detailsBrokerItemUsername,
                                ),
                                labelStyle: TextStyle(
                                    color: Theme.of(context).accentColor),
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                broker.username,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ],
                          )
                        : Container(),
                    const SizedBox(height: 5.0),
                    broker.privateKeyPassword != null
                        ? Row(
                            children: [
                              Chip(
                                label: const Text(
                                  'Private Key Password',
                                  key: AppKeys
                                      .detailsBrokerItemPrivateKeyPassword,
                                ),
                                labelStyle: TextStyle(
                                    color: Theme.of(context).accentColor),
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                broker.privateKeyPassword,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            ],
                          )
                        : Container(),
                    const SizedBox(height: 5.0),
                  ],
                )
              : Container(),
          floatingActionButton: FloatingActionButton(
            key: AppKeys.editBrokerFab,
            onPressed: broker != null
                ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return AddEditBrokerScreen(
                            onSave: (name,
                                address,
                                identifier,
                                port,
                                username,
                                password,
                                qos,
                                secure,
                                certificatePath,
                                privateKeyPath,
                                privateKeyPassword,
                                clientAuthorityPath) {
                              context.read<BrokerBloc>().add(
                                    BrokerUpdated(
                                      broker.copyWith(
                                          name: name,
                                          address: address,
                                          identifier: identifier,
                                          port: port,
                                          username: username,
                                          password: password,
                                          qos: qos,
                                          secure: secure),
                                    ),
                                  );
                            },
                            isEditing: true,
                            broker: broker,
                          );
                        },
                      ),
                    );
                  }
                : null,
            child: Icon(Icons.edit, color: Theme.of(context).primaryColor),
          ),
        );
      },
    );
  }
}
