import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../settings/localization.dart';

class DeleteWidgetSnackBar extends SnackBar {
  final FlutterBlocLocalizations localizations;

  DeleteWidgetSnackBar({
    Key key,
    @required WidgetItem widgetItem,
    @required VoidCallback onUndo,
    @required this.localizations,
  }) : super(
          key: key,
          //localizations.brokerDeleted,
          content: Text(
            'Deleted ${widgetItem.name} widget',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: localizations.undo,
            onPressed: onUndo,
          ),
        );
}
