import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_flutter_bloc/widgets/utils/wait_message.dart';

import '../blocs/blocs.dart';
import '../models/models.dart';

class MessagesView extends StatefulWidget {
  const MessagesView({Key key}) : super(key: key);

  @override
  _MessagesViewState createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _topicController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  bool _retainValue = false;
  int _qosValue;

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return DefaultTabController(
      length: 2,
      child: Column(
        children: <Widget>[
          const TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Received',
              ),
              Tab(
                text: 'Send',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: <Widget>[
                BlocBuilder<MessageBloc, MessageState>(
                  builder: (context, state) {
                    if (state is BrokerConnectionFailed) {
                      return const WaitMessage(
                          message: 'No broker connected...');
                    } else if (state is MessagesReceptionSuccess) {
                      return Column(
                        children: [
                          Flexible(
                            child: state.messages.isNotEmpty
                                ? ListView.builder(
                                    itemCount: state.messages.length,
                                    itemBuilder: (context, index) {
                                      final message = state.messages[index];
                                      return Card(
                                        child: ListTile(
                                          trailing: CircleAvatar(
                                            radius: 14.0,
                                            backgroundColor:
                                                Theme.of(context).primaryColor,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  'QoS',
                                                  style: TextStyle(
                                                      fontSize: 8.0,
                                                      color: Theme.of(context)
                                                          .accentColor),
                                                ),
                                                Text(
                                                  message.qos.toString(),
                                                  style: TextStyle(
                                                      fontSize: 8.0,
                                                      color: Theme.of(context)
                                                          .accentColor),
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
                                : const WaitMessage(
                                    message: 'No message received...'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Theme.of(context).primaryColorDark),
                              ),
                              onPressed: () {
                                context
                                    .read<MessageBloc>()
                                    .add(BrokerMessagesCleared());
                              },
                              child: const Text('Clear'),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: Text('Oups, this is not supposed to happen'),
                      );
                    }
                  },
                ),
                Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        alignment: Alignment.bottomLeft,
                        child: TextFormField(
                          controller: _messageController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            hintText: 'Message',
                          ),
                          validator: (val) {
                            return val.trim().isEmpty
                                ? 'Message is empty'
                                : null;
                          },
                          onEditingComplete: () => node.nextFocus(),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        alignment: Alignment.bottomLeft,
                        child: TextFormField(
                          controller: _topicController,
                          decoration: const InputDecoration(
                            hintText: 'Topic',
                          ),
                          validator: (val) {
                            if (val.trim().isEmpty) {
                              return 'Topic is empty';
                            } else if (context.read<MqttBloc>().state
                                    is MqttDisconnectionSuccess ||
                                context.read<MqttBloc>().state is MqttIdle) {
                              return 'First, establish a broker connection !';
                            }
                            return null;
                          },
                        ),
                      ),
                      Wrap(
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
                      ),
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
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            context.read<MessageBloc>().add(
                                  BrokerMessageSended(
                                    Message(
                                        payload: _messageController.value.text,
                                        topic: _topicController.value.text,
                                        qos: _qosValue,
                                        retainValue: _retainValue),
                                  ),
                                );
                            setState(() {
                              _qosValue = null;
                              _retainValue = false;
                            });
                            _topicController.clear();
                            _messageController.clear();
                          }
                        },
                        child: const Text('Send'),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
