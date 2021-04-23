import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/models.dart';
import '../blocs/blocs.dart';
import '../settings/localization.dart';

typedef OnSaveCallback = Function(String name, String type, String topic);

class AddEditWidgetScreen extends StatefulWidget {
  final bool isEditing;
  final OnSaveCallback onSave;
  final WidgetItem widgetItem;

  AddEditWidgetScreen({
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

  static List<String> _widgetTypeList = [
    'Maps',
    'Gauge',
    'Button',
    'Indicator'
  ];

  bool _contentVisible = false;
  int _qosValue = 0;

  bool get isEditing => widget.isEditing;

  @override
  Widget build(BuildContext context) {
    final localizations = FlutterBlocLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final node = FocusScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? localizations.editWidget : localizations.addWidget,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                hint: Text("Widget type"),
                items: _widgetTypeList
                    .map<DropdownMenuItem<String>>(
                        (String widgetType) => DropdownMenuItem<String>(
                              child: Text(widgetType),
                              value: widgetType,
                            ))
                    .toList(),
                decoration: InputDecoration(
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
                      hint: Text("Topic's name"),
                      disabledHint: Text("No topic subscribed"),
                      items: state.topicTitles != null
                          ? state.topicTitles
                              .map<DropdownMenuItem<String>>(
                                  (String subTopic) => DropdownMenuItem<String>(
                                        child: Text(subTopic),
                                        value: subTopic,
                                      ))
                              .toList()
                          : null,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      onSaved: (value) => _topic = value,
                    );
                  } else {
                    return Center(
                      child: Text('Oups, an error occured !'),
                    );
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: ElevatedButton(
                  child: Text(isEditing ? 'Valid Widget' : 'Add Widget'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      // TODO everys parameters for Widget Broker
                      widget.onSave(_name, _type, _topic);
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
