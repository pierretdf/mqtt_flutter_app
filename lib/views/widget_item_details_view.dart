import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_flutter_bloc/settings/keys.dart';
import 'package:mqtt_flutter_bloc/widgets/widgets.dart';

import '../blocs/blocs.dart';
import '../settings/localization.dart';
import 'add_edit_widget_view.dart';

class WidgetItemDetailsScreen extends StatelessWidget {
  final int id;

  const WidgetItemDetailsScreen({Key key, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WidgetBloc, WidgetState>(
      builder: (context, state) {
        final widgetItem = (state as WidgetItemLoadSuccess)
            .widgetItems
            .firstWhere((widgetItem) => widgetItem.id == id,
                orElse: () => null);
        final localizations = FlutterBlocLocalizations.of(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(localizations.widgetDetails,
                style: TextStyle(color: Theme.of(context).primaryColorDark)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.red),
                key: AppKeys.deleteBrokerButton,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return FloatingBottomSheet(
                        title: 'Attention',
                        description:
                            'Are you sur to delete the ${widgetItem.name} widget ?',
                        mainButtonTitle: 'Delete',
                        onPressed: () {
                          context
                              .read<WidgetBloc>()
                              .add(WidgetItemDeleted(widgetItem));
                          Navigator.of(context).pop();
                          // To quit the Widget Details Page
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  );
                },
              )
            ],
          ),
          body: widgetItem != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Padding(
                          //   padding: EdgeInsets.only(right: 8.0),
                          //   child: Checkbox(
                          //       value: widgetItem.SOMETHING,
                          //       onChanged: (_) {
                          //         context.read<WidgetBloc>().add(
                          //           WidgetItemUpdated(
                          //             broker.copyWith(parameters),
                          //           ),
                          //         );
                          //       }),
                          // ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Hero(
                                  tag: '${widgetItem.id}__heroTag',
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.only(
                                      top: 8.0,
                                      bottom: 16.0,
                                    ),
                                    child: Text(
                                      widgetItem.name ?? 'Unnamed',
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  ),
                                ),
                                Text(
                                  widgetItem.topic ?? 'No Topic',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : Container(),
          floatingActionButton: FloatingActionButton(
            key: AppKeys.editWidgetFab,
            onPressed: widgetItem != null
                ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return AddEditWidgetScreen(
                            onSave: (name, type, topic) {
                              context.read<WidgetBloc>().add(
                                    WidgetItemUpdated(
                                      widgetItem.copyWith(
                                          name: name, type: type, topic: topic),
                                    ),
                                  );
                            },
                            isEditing: true,
                            widgetItem: widgetItem,
                          );
                        },
                      ),
                    );
                  }
                : null,
            child: Icon(Icons.edit, color: Theme.of(context).primaryColor),
          ),
        );
      },
    );
  }
}
