import 'package:flutter/material.dart';

import '../../models/models.dart';

class WidgetItemItem extends StatelessWidget {
  final GestureTapCallback onTapDetails;
  //final DismissDirectionCallback onDismissed;
  final WidgetItem widgetItem;

  const WidgetItemItem({
    Key key,
    @required this.onTapDetails,
    //@required this.onDismissed,
    @required this.widgetItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        children: <Widget>[
          Text('Hello World !'),
          // TODO choose widget depends of widgetItem.type
          // widgetItem.type == 'Maps'
          //     ? MapsWidget(payload: widgetItem.payload)
          //     : widgetItem.type == 'Gauge'
          //         ? GaugeWidget(payload: widgetItem.payload)
          //         : widgetItem.type == 'Indicator'
          //             ? IndicatorWidget(payload: widgetItem.payload)
          //             : ButtonWidget(payload: widgetItem.payload),
          ListTile(
            title: Text(widgetItem.name ?? 'Unnamed Widget'),
            trailing: Text(widgetItem.topic ?? 'No topic'),
            onTap: onTapDetails,
          ),
        ],
      ),
    );
  }
}

// Dismissible(
//       key: AppKeys.widgetItem(widgetItem.id),
//       onDismissed: onDismissed,
//       child: 
