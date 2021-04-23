import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import '../models/models.dart';
import '../settings/localization.dart';
import '../widgets/widgets.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, AppTab>(
      builder: (context, activeTab) {
        return Scaffold(
          appBar: AppBar(
            title: Text(FlutterBlocLocalizations.of(context).appTitle),
          ),
          body: activeTab == AppTab.brokers
              ? BrokersView()
              : activeTab == AppTab.subscriptions
                  ? SubscriptionsView()
                  : activeTab == AppTab.messages
                      ? MessagesView()
                      : WidgetItemsView(),
          bottomNavigationBar: TabSelector(
            activeTab: activeTab,
            onTabSelected: (tab) =>
                context.read<TabBloc>().add(TabUpdated(tab)),
          ),
        );
      },
    );
  }
}
