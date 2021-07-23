import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../settings/keys.dart';
import '../widgets.dart';

class WidgetItemItem extends StatelessWidget {
  final GestureTapCallback onTapDetails;
  final DismissDirectionCallback onDismissed;
  final WidgetItem widgetItem;

  const WidgetItemItem({
    Key key,
    @required this.onTapDetails,
    @required this.onDismissed,
    @required this.widgetItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: AppKeys.widgetItem(widgetItem.id),
      onDismissed: onDismissed,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: GestureDetector(
          onTap: onTapDetails,
          child: Column(
            children: <Widget>[
              // TODO choose widget depends of widgetItem.type
              widgetItem.type == 'Maps'
                  ? MapsWidget(payload: widgetItem.payload)
                  : widgetItem.type == 'Gauge'
                      ? GaugeWidget(payload: widgetItem.payload)
                      : widgetItem.type == 'Indicator'
                          ? IndicatorWidget(payload: widgetItem.payload)
                          : ButtonWidget(payload: widgetItem.payload),
              ListTile(
                title: Text(widgetItem.name ?? 'Unnamed Widget'),
                trailing: Text(widgetItem.topic ?? 'No topic'),
              ),
            ],
          ),
        ),

      ),
    );
  }
}
