import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../settings/localization.dart';

class DeleteBrokerSnackBar extends SnackBar {
  final FlutterBlocLocalizations localizations;

  DeleteBrokerSnackBar({
    Key key,
    @required Broker broker,
    @required VoidCallback onUndo,
    @required this.localizations,
  }) : super(
          key: key,
          // localizations.brokerDeleted,
          content: Text(
            'Deleted ${broker.name} widget',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          duration: Duration(seconds: 2),
          action: SnackBarAction(
            label: localizations.undo,
            onPressed: onUndo,
          ),
        );
}
