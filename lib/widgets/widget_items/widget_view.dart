import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/blocs.dart';
import '../../settings/localization.dart';
import '../../views/widget_item_details_view.dart';
import '../widgets.dart';

class WidgetItemsView extends StatelessWidget {
  WidgetItemsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = FlutterBlocLocalizations.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor:
            Theme.of(context).floatingActionButtonTheme.backgroundColor,
        label: Text('Widget',
            style: TextStyle(color: Theme.of(context).accentColor)),
        icon: Icon(Icons.add, color: Theme.of(context).accentColor),
        onPressed: () {
          Navigator.pushNamed(context, '/add_widget');
        },
      ),
      body: BlocBuilder<WidgetBloc, WidgetState>(
        builder: (context, state) {
          if (state is WidgetItemLoadInProgress) {
            return LoadingIndicator();
          } else if (state is WidgetItemLoadSuccess) {
            return state.widgetItems.length != 0
                ? ListView.builder(
                    itemCount: state.widgetItems.length,
                    itemBuilder: (context, index) {
                      final widgetItem = state.widgetItems[index];
                      return WidgetItemItem(
                        widgetItem: widgetItem,
                        onDismissed: (direction) {
                          context
                              .read<WidgetBloc>()
                              .add(WidgetItemDeleted(widgetItem));
                          ScaffoldMessenger.of(context).showSnackBar(
                            DeleteWidgetSnackBar(
                              // key: ArchSampleKeys.snackbar,
                              widgetItem: widgetItem,
                              onUndo: () => context
                                  .read<WidgetBloc>()
                                  .add(WidgetItemAdded(widgetItem)),
                              localizations: localizations,
                            ),
                          );
                        },
                        onTap: () async {
                          final removedWidgetItem =
                              await Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) {
                              return WidgetItemDetailsScreen(id: widgetItem.id);
                            }),
                          );
                          if (removedWidgetItem != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              DeleteWidgetSnackBar(
                                widgetItem: widgetItem,
                                onUndo: () => context
                                    .read<WidgetBloc>()
                                    .add(WidgetItemAdded(widgetItem)),
                                localizations: localizations,
                              ),
                            );
                          }
                        },
                      );
                    },
                  )
                : _noWidgetItemsMessage();
          } else if (state is WidgetItemLoadFailure) {
            return Center(
              child: Text('Error occured: ${state.error}'),
            );
          } else {
            return Center(
              child: Text('Oups, this is not supposed to happen'),
            );
          }
        },
      ),
    );
  }

  Widget _noWidgetItemsMessage() {
    return Center(
      child: Text(
        "Start adding a widget...",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
