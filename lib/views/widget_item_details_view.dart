import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_flutter_bloc/settings/keys.dart';

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
            title: Center(child: Text(localizations.widgetDetails)),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  context.read<WidgetBloc>().add(WidgetItemDeleted(widgetItem));
                  Navigator.pop(context, widgetItem);
                },
              )
            ],
          ),
          body: widgetItem == null
              ? Container()
              : Padding(
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
                                      widgetItem.name,
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  ),
                                ),
                                Text(
                                  widgetItem.topic,
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            key: AppKeys.editWidgetFab,
            onPressed: widgetItem == null
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return AddEditWidgetScreen(
                            onSave: (name, type, topic) {
                              context.read<WidgetBloc>().add(
                                    WidgetItemUpdated(
                                      widgetItem.copyWith(
                                          name: name, type: type, topic: topic),
                                      // TODO add arguments for widget config
                                    ),
                                  );
                            },
                            isEditing: true,
                            widgetItem: widgetItem,
                          );
                        },
                      ),
                    );
                  },
            child: const Icon(Icons.edit),
          ),
        );
      },
    );
  }
}
