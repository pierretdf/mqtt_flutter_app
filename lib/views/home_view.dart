import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import '../models/models.dart';
import '../settings/localization.dart';
import '../widgets/widgets.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MqttBloc, MqttState>(
      builder: (context, mqttState) {
        return BlocBuilder<TabBloc, AppTab>(
          builder: (context, activeTab) {
            return Scaffold(
              appBar: AppBar(
                title: mqttState is MqttDisconnectionSuccess ||
                        mqttState is MqttIdle
                    ? Text('Disconnected',
                        style: TextStyle(
                            color: Theme.of(context).primaryColorDark))
                    : Text('Connected',
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryColorDark)), //FlutterBlocLocalizations.of(context).appTitle
                centerTitle: true,
              ),
              body: activeTab == AppTab.brokers
                  ? const BrokersView()
                  : activeTab == AppTab.subscriptions
                      ? const SubscriptionsView()
                      : activeTab == AppTab.messages
                          ? const MessagesView()
                          : const WidgetItemsView(),
              bottomNavigationBar: TabSelector(
                activeTab: activeTab,
                onTabSelected: (tab) =>
                    context.read<TabBloc>().add(TabUpdated(tab)),
              ),
            );
          },
        );
      },
    );
  }
}
