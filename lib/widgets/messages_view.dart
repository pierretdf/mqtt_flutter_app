import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/blocs.dart';
import '../models/models.dart';

import '../settings/localization.dart';

class MessagesView extends StatefulWidget {
  MessagesView({Key key}) : super(key: key);

  @override
  _MessagesViewState createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  Message _message;
  bool _retainValue = false;
  int _qosValue;

  //final ValueChanged<bool> onCheckboxChanged;

  @override
  Widget build(BuildContext context) {
    final localizations = FlutterBlocLocalizations.of(context);

    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              children: <Widget>[
                _buildReceive(),
                _buildSend(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      child: TabBar(
        tabs: <Widget>[
          Tab(
            text: "Reçu",
          ),
          Tab(
            text: "Envoyer",
          ),
        ],
        labelColor: Theme.of(context).tabBarTheme.labelColor,
        indicatorColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildReceive() {
    return BlocBuilder<MessageBloc, MessageState>(
      builder: (context, state) {
        if (state is NoBrokerConnected) {
          return _noBrokerConnectedMessage();
        } else if (state is MessagesReceptionSuccess) {
          return Column(
            children: [
              Flexible(
                child: state.messages.length != 0
                    ? ListView.builder(
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final message = state.messages[index];
                          return Card(
                            color: Colors.white70,
                            child: ListTile(
                              trailing: CircleAvatar(
                                radius: 14.0,
                                backgroundColor: Theme.of(context).accentColor,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'QoS',
                                      style: TextStyle(fontSize: 8.0),
                                    ),
                                    Text(
                                      message.qos.toString(),
                                      style: TextStyle(fontSize: 8.0),
                                    ),
                                  ],
                                ),
                              ),
                              title: Text(message.topic),
                              subtitle: Text(message.payload),
                              dense: true,
                            ),
                          );
                        },
                      )
                    : _noMessagesReceivedMessage(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black54),
                  ),
                  child: Text('Clear'),
                  onPressed: () {
                    context
                        .read<MessageBloc>()
                        .add(BrokerMessagesCleared()); //state.messages
                  },
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: Text('Oups, this is not supposed to happen'),
          );
        }
      },
    );
  }

  Widget _buildSend() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            alignment: Alignment.bottomLeft,
            child: TextFormField(
              controller: _messageController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Message',
              ),
              validator: (val) {
                if (val.trim().isEmpty) {
                  return 'Message is empty';
                }
                return null;
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            alignment: Alignment.bottomLeft,
            child: TextFormField(
              controller: _topicController,
              decoration: const InputDecoration(
                labelText: 'Topic',
              ),
              validator: (val) {
                if (val.trim().isEmpty) {
                  return 'Topic is empty';
                } else if (context.read<MqttBloc>().state is MqttDisconnected ||
                    context.read<MqttBloc>().state is MqttIdle) {
                  return 'First, establish a broker connection !';
                }
                return null;
              },
            ),
          ),
          _buildQosChoiceChips(),
          Row(
            children: <Widget>[
              Checkbox(
                  value: _retainValue,
                  onChanged: (bool value) {
                    setState(() {
                      _retainValue = value;
                    });
                  }),
              const Text('Retained'),
            ],
          ),
          ElevatedButton(
            child: Text('Send'),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                // _message.payload = _messageController.value.text;
                // _message.topic = _topicController.value.text;
                // _message.qos = _qosValue;
                // _message.retainValue = _retainValue;
                // context.read<MessageBloc>().add(BrokerMessageSended(_message));
                context.read<MessageBloc>().add(
                      BrokerMessageSended(
                        Message(
                            payload: _messageController.value.text,
                            topic: _topicController.value.text,
                            qos: _qosValue,
                            retainValue: _retainValue),
                      ),
                    );
                // TODO clear selected qos in ChoiceChip
                // _qosValue = 0;
                _topicController.clear();
                _messageController.clear();
              }
            },
          )
        ],
      ),
    );
  }

  Wrap _buildQosChoiceChips() {
    return Wrap(
      spacing: 4.0,
      children: List<Widget>.generate(
        3,
        (int index) {
          return ChoiceChip(
            label: Text('QoS level $index'),
            selected: _qosValue == index,
            onSelected: (bool selected) {
              setState(() {
                _qosValue = selected ? index : null;
              });
            },
          );
        },
      ).toList(),
    );
  }

  Widget _noBrokerConnectedMessage() {
    return Center(
      child: Text(
        "No broker connected...",
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _noMessagesReceivedMessage() {
    return Center(
      child: Text(
        "No message received...",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
