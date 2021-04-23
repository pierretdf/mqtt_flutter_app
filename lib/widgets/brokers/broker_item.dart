import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../models/models.dart';
import '../../settings/keys.dart';
import '../widgets.dart';

class BrokerItem extends StatelessWidget {
  final DismissDirectionCallback onDismissed;
  final GestureTapCallback onTapDetails;
  final GestureTapCallback onTapMqtt;
  final Broker broker;

  BrokerItem({
    Key key,
    @required this.onDismissed,
    @required this.onTapDetails,
    @required this.broker,
    @required this.onTapMqtt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ArchSampleKeys.brokerItem(broker.id),
      onDismissed: onDismissed,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        color: Theme.of(context).cardColor,
        child: ListTile(
          leading: GestureDetector(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Icon(_iconState(broker.state),
                      color: Theme.of(context).textTheme.bodyText1.color,
                      size: 30),
                ),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _colorState(broker.state),
                  ),
                ),
              ],
            ),
            onTap: onTapMqtt,
          ),
          title: Text(broker.name ?? 'Unnamed broker'),
          subtitle: Text(
            "${broker.address ?? 'No broker address'} / ${broker.port ?? 'No broker port'}",
            key: ArchSampleKeys.brokerItemNote(broker.id),
            style: Theme.of(context).textTheme.subtitle1,
          ),
          trailing: GestureDetector(
            child: Icon(Icons.delete_forever, color: Colors.red, size: 30),
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (BuildContext context) {
                  return FloatingBottomSheet(
                    title: 'Attention',
                    description:
                        'Are you sur to delete the ${broker.name} broker ?',
                    mainButtonTitle: 'Delete',
                    function: broker,
                  );
                },
              );
            },
          ),
          onTap: onTapDetails,
        ),
      ),
    );
  }

  IconData _iconState(String brokerState) {
    switch (brokerState) {
      case 'connected':
        return Icons.cloud_done_sharp;
        break;
      case 'connecting':
        return Icons.cloud_download_sharp;
        break;
      case 'connectedSubscribed':
        return Icons.cloud_done_sharp;
        break;
      case 'connectedUnsubscribed':
        return Icons.cloud_done_sharp;
        break;
      case 'disconnected':
        return Icons.cloud_off_sharp;
        break;
      default:
        return Icons.cloud_off_sharp;
    }
  }

  MaterialColor _colorState(String brokerState) {
    switch (brokerState) {
      case 'connected':
        return Colors.green;
        break;
      case 'connecting':
        return Colors.orange;
        break;
      case 'connectedSubscribed':
        return Colors.green;
        break;
      case 'connectedUnsubscribed':
        return Colors.green;
        break;
      case 'disconnected':
        return Colors.red;
        break;
      default:
        return Colors.red;
    }
  }
}
