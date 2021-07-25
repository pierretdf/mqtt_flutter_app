import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../settings/keys.dart';
import '../widgets.dart';

class BrokerItem extends StatelessWidget {
  final GestureTapCallback onTapDetails;
  final GestureTapCallback onTapMqtt;
  final VoidCallback onPressedDelete;
  final Broker broker;

  const BrokerItem({
    Key key,
    @required this.onTapDetails,
    @required this.broker,
    @required this.onTapMqtt,
    @required this.onPressedDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: ListTile(
          leading: GestureDetector(
            onTap: onTapMqtt,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Icon(_iconState(broker.state),
                      color: Theme.of(context).primaryColorDark,//Theme.of(context).primaryColorDark
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
          ),
          title: Text(
            broker.name ?? 'Unnamed broker',
            key: AppKeys.brokerItemName(broker.id),
            //style: Theme.of(context).textTheme.bodyText1,
          ),
          subtitle: Text(
            "${broker.address ?? 'No broker address'} / ${broker.port ?? 'No broker port'}",
            key: AppKeys.brokerItemAddress(broker.id),
            style: Theme.of(context).textTheme.subtitle1,
          ),
          trailing: GestureDetector(
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
                    onPressed: onPressedDelete,
                  );
                },
              );
            },
            child:
                const Icon(Icons.delete_forever, color: Colors.red, size: 30),
          ),
          onTap: onTapDetails,
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