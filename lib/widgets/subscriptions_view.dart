import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import '../models/models.dart';
import '../settings/localization.dart';
import 'widgets.dart';

class SubscriptionsView extends StatefulWidget {
  SubscriptionsView({Key key}) : super(key: key);

  @override
  _SubscriptionsViewState createState() => _SubscriptionsViewState();
}

class _SubscriptionsViewState extends State<SubscriptionsView> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _topicController = TextEditingController();

  String _topic;

  @override
  Widget build(BuildContext context) {
    final localizations = FlutterBlocLocalizations.of(context);
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        if (state is SubscribedTopicsInProgress) {
          return LoadingIndicator();
        } else if (state is SubscribedTopicsLoadSuccess) {
          return Column(
            children: [
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        controller: _topicController,
                        decoration: InputDecoration(
                          hintText: localizations.newTopic,
                        ),
                        validator: (val) {
                          if (val.trim().isEmpty) {
                            return localizations.emptyTopicTitleError;
                          } else if (context.read<MqttBloc>().state
                                  is MqttDisconnected ||
                              context.read<MqttBloc>().state is MqttIdle) {
                            return 'First, establish a broker connection !';
                          } else if (state.topicTitles.contains(val.trim())) {
                            return 'This topic is already subscribed !';
                          }
                          return null;
                        },
                        onSaved: (value) => _topic = value,
                      ),
                      ElevatedButton(
                        child: Text('Add topic'),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            context.read<SubscriptionBloc>().add(TopicAdded(
                                Topic(
                                    title: _topic,
                                    // Retrieve connected Broker Id
                                    brokerId: context
                                        .read<MqttBloc>()
                                        .mqttRepository
                                        .connectedBrokerId())));
                            _topicController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              context.read<MqttBloc>().state is MqttConnected
                  ? state.topics.length != 0
                      ? Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          alignment: WrapAlignment.start,
                          children: _buildTopicList(state.topics),
                        )
                      : _noTopicMessage()
                  : _noBrokerConnectedMessage(),
            ],
          );
        } else if (state is SubscribedTopicsFailure) {
          return Center(child: Text('Failed to load topics'));
        } else {
          return Center(
            child: Text('Oups, this is not supposed to happen'),
          );
        }
      },
    );
  }

  List<Widget> _buildTopicList(List<Topic> topics) {
    return topics
        .map(
          (Topic topic) => Chip(
            label: Text(topic.title),
            onDeleted: () {
              context.read<SubscriptionBloc>().add(TopicDeleted(topic));
            },
          ),
        )
        .toList();
  }

  Widget _noBrokerConnectedMessage() {
    return Container(
      child: Text(
        "No broker connected...",
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget _noTopicMessage() {
    return Container(
      child: Text(
        "Start adding Topic...",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
