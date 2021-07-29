import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/blocs.dart';
import '../models/models.dart';
import '../settings/localization.dart';
import 'utils/wait_message.dart';
import 'widgets.dart';

class SubscriptionsView extends StatefulWidget {
  const SubscriptionsView({Key key}) : super(key: key);

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
          return const LoadingIndicator();
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
                          } else if (state.topicsTitle.contains(val.trim())) {
                            return 'This topic is already subscribed !';
                          }
                          return null;
                        },
                        onSaved: (value) => _topic = value,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            context.read<SubscriptionBloc>().add(TopicAdded(
                                Topic(
                                    title: _topic,
                                    brokerId: context
                                        .read<MqttBloc>()
                                        .mqttRepository
                                        .getConnectedBrokerId())));
                            _topicController.clear();
                          }
                        },
                        child: const Text('Add topic'),
                      ),
                    ],
                  ),
                ),
              ),
              if (context.read<MqttBloc>().state is MqttConnectionSuccess)
                state.topics.isNotEmpty
                    ? Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: _buildTopicList(state.topics),
                      )
                    : const WaitMessage(message: 'Start adding topic...')
              else
                const WaitMessage(message: 'No broker connected...'),
            ],
          );
        } else if (state is SubscribedTopicsFailure) {
          return const Center(child: Text('Failed to load topics'));
        } else {
          return const Center(
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
}
