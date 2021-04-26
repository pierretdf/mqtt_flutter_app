import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_flutter_bloc/blocs/blocs.dart';

import '../models/models.dart';
import '../settings/localization.dart';

typedef OnSaveCallback = Function(String name, String type, String topic);

class AddEditWidgetScreen extends StatefulWidget {
  final bool isEditing;
  final OnSaveCallback onSave;
  final WidgetItem widgetItem;

  const AddEditWidgetScreen({
    Key key,
    @required this.onSave,
    @required this.isEditing,
    this.widgetItem,
  }) : super(key: key);

  @override
  _AddEditWidgetScreenState createState() => _AddEditWidgetScreenState();
}

class _AddEditWidgetScreenState extends State<AddEditWidgetScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name;
  String _type;
  String _topic;

  static final List<String> _widgetTypeList = [
    'Maps',
    'Gauge',
    'Button',
    'Indicator'
  ];

  final bool _contentVisible = false;
  final int _qosValue = 0;

  bool get isEditing => widget.isEditing;

  @override
  Widget build(BuildContext context) {
    final localizations = FlutterBlocLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final node = FocusScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            isEditing ? localizations.editWidget : localizations.addWidget,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                hint: const Text('Widget type'),
                items: _widgetTypeList
                    .map<DropdownMenuItem<String>>(
                        (String widgetType) => DropdownMenuItem<String>(
                              value: widgetType,
                              child: Text(widgetType),
                            ))
                    .toList(),
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                onChanged: (String newValue) {},
                onTap: () {
                  FocusManager.instance.primaryFocus.unfocus();
                },
              ),
              TextFormField(
                initialValue: isEditing ? widget.widgetItem.name : '',
                autofocus: !isEditing,
                style: textTheme.headline5,
                decoration: InputDecoration(
                  hintText: localizations.newWidgetName,
                ),
                validator: (val) {
                  return val.trim().isEmpty
                      ? localizations.emptyBrokerError
                      : null;
                },
                onSaved: (value) => _name = value,
                onEditingComplete: () => node.nextFocus(),
              ),
              TextFormField(
                initialValue: isEditing ? widget.widgetItem.type : '',
                autofocus: !isEditing,
                style: textTheme.headline5,
                decoration: InputDecoration(
                  hintText: localizations.newWidgetType,
                ),
                validator: (val) {
                  return val.trim().isEmpty
                      ? localizations.emptyBrokerError
                      : null;
                },
                onSaved: (value) => _type = value,
                onEditingComplete: () => node.nextFocus(),
              ),
              BlocBuilder<SubscriptionBloc, SubscriptionState>(
                builder: (context, state) {
                  if (state is SubscribedTopicsLoadSuccess) {
                    return DropdownButtonFormField<String>(
                      hint: const Text("Topic's name"),
                      disabledHint: const Text('No topic subscribed'),
                      items: state.topicTitles
                          ?.map<DropdownMenuItem<String>>(
                              (String subTopic) => DropdownMenuItem<String>(
                                    value: subTopic,
                                    child: Text(subTopic),
                                  ))
                          ?.toList(),
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      onSaved: (value) => _topic = value,
                    );
                  } else {
                    return const Center(
                      child: Text('Oups, an error occured !'),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      // TODO everys parameters for Widget Broker
                      widget.onSave(_name, _type, _topic);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(isEditing ? 'Valid Widget' : 'Add Widget'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
