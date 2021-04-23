import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/models.dart';
import '../../settings/keys.dart';
import '../../settings/localization.dart';

class TabSelector extends StatelessWidget {
  final AppTab activeTab;
  final Function(AppTab) onTabSelected;

  TabSelector({
    Key key,
    @required this.activeTab,
    @required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      fixedColor: Theme.of(context).accentColor,
      backgroundColor:
          Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      currentIndex: AppTab.values.indexOf(activeTab),
      onTap: (index) => onTabSelected(AppTab.values[index]),
      items: AppTab.values.map((tab) {
        return BottomNavigationBarItem(
          icon: Icon(
            tab == AppTab.brokers
                ? Icons.cloud
                : tab == AppTab.subscriptions
                    ? Icons.playlist_add
                    : tab == AppTab.messages
                        ? Icons.message
                        : Icons.widgets,
            key: tab == AppTab.brokers
                ? ArchSampleKeys.brokersTab
                : tab == AppTab.subscriptions
                    ? ArchSampleKeys.subscriptionsTab
                    : tab == AppTab.messages
                        ? ArchSampleKeys.messagesTab
                        : ArchSampleKeys.widgetsTab,
          ),
          label: tab == AppTab.brokers
              ? FlutterBlocLocalizations.of(context).brokers
              : tab == AppTab.subscriptions
                  ? FlutterBlocLocalizations.of(context).subscriptions
                  : tab == AppTab.messages
                      ? FlutterBlocLocalizations.of(context).messages
                      : FlutterBlocLocalizations.of(context).widgets,
        );
      }).toList(),
    );
  }
}
