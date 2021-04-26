import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/models.dart';
import '../../services/mqtt_repository.dart';
import '../../services/topic_repository.dart';
import '../blocs.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  final TopicRepository topicRepository;
  final MqttRepository mqttRepository;
  StreamSubscription _mqttState;

  SubscriptionBloc(this.topicRepository, this.mqttRepository)
      : super(SubscribedTopicsInProgress());

  @override
  Stream<SubscriptionState> mapEventToState(SubscriptionEvent event) async* {
    if (event is SubscribedTopicsLoaded) {
      // TODO retrieve brokerId of topics list
      yield* _mapTopicSubscribedLoadedToState();
    } else if (event is TopicAdded) {
      yield* _mapTopicAddedToState(event);
    } else if (event is TopicDeleted) {
      yield* _mapTopicDeletedToState(event);
    }
  }

  Stream<SubscriptionState> _mapTopicSubscribedLoadedToState() async* {
    // int brokerId
    try {
      final topics = await topicRepository.getTopics();
      final topicTitles = await topicRepository.getTopicsTitle();
      yield SubscribedTopicsLoadSuccess(topics, topicTitles);
    } catch (e) {
      //yield SubscribedTopicsFailure(error: e);
    }
  }

  Stream<SubscriptionState> _mapTopicAddedToState(TopicAdded event) async* {
    if (state is SubscribedTopicsLoadSuccess) {
      final updatedTopics =
          List<Topic>.from((state as SubscribedTopicsLoadSuccess).topics)
            ..add(event.topic);
      await topicRepository.addTopic(event.topic);
      final updatedTopicTitles = await topicRepository.getTopicsTitle();
      yield SubscribedTopicsLoadSuccess(updatedTopics, updatedTopicTitles);
      mqttRepository.subscribeToTopic(event.topic.title);
    }
  }

  Stream<SubscriptionState> _mapTopicDeletedToState(TopicDeleted event) async* {
    if (state is SubscribedTopicsLoadSuccess) {
      // Delete Topic from 'subscriptions_view' (UI)
      final updatedTopics = (state as SubscribedTopicsLoadSuccess)
          .topics
          .where((topic) => topic.id != event.topic.id)
          .toList();
      mqttRepository.unSubscribeFromTopic(event.topic.title);
      await topicRepository.deleteTopic(event.topic.id);
      final updatedTopicTitles = await topicRepository.getTopicsTitle();
      yield SubscribedTopicsLoadSuccess(updatedTopics, updatedTopicTitles);
    }
  }

  @override
  Future<void> close() {
    _mqttState.cancel();
    return super.close();
  }
}
