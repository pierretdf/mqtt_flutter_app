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
                    color: Theme.of(context)
                        .primaryColorDark, //Theme.of(context).primaryColorDark
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
          child: const Icon(Icons.delete_forever, color: Colors.red, size: 30),
        ),
        onTap: onTapDetails,
      ),
    );
  }

  IconData _iconState(String brokerState) {
    switch (brokerState) {
      case 'connected':
        return Icons.cloud_done_sharp;
      case 'connecting':
        return Icons.cloud_download_sharp;
      case 'disconnected':
        return Icons.cloud_off_sharp;
      case 'failed':
        return Icons.cloud_off_sharp;
      default:
        return Icons.cloud_off_sharp;
    }
  }

  MaterialColor _colorState(String brokerState) {
    switch (brokerState) {
      case 'connected':
        return Colors.green;
      case 'connecting':
        return Colors.orange;
      case 'connectedSubscribed':
        return Colors.green;
      case 'connectedUnsubscribed':
        return Colors.green;
      case 'disconnected':
        return Colors.red;
      default:
        return Colors.red;
    }
  }
}
