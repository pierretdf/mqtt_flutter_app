import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../settings/keys.dart';
import '../widgets.dart';

class WidgetItemItem extends StatelessWidget {
  final DismissDirectionCallback onDismissed;
  final GestureTapCallback onTap;
  final WidgetItem widgetItem;

  const WidgetItemItem({
    Key key,
    @required this.onDismissed,
    @required this.onTap,
    @required this.widgetItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: AppKeys.widgetItem(widgetItem.id),
      onDismissed: onDismissed,
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey[200], width: 0.5),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: <Widget>[
            // TODO choose widget depends of widgetItem.type
            if (widgetItem.type == 'Maps')
              const MapsWidget()
            else
              widgetItem.type == 'Gauge'
                  ? const GaugeWidget()
                  : widgetItem.type == 'Indicator'
                      ? const IndicatorWidget()
                      : const ButtonWidget(),
            ListTile(
              title: Text(widgetItem.name ?? 'Unnamed Widget'),
              trailing: Text(widgetItem.topic ?? 'No topic'),
            ),
          ],
        ),
      ),
    );
  }
}
