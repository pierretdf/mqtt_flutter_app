import 'package:equatable/equatable.dart';

import '../../models/models.dart';

abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();

  @override
  List<Object> get props => [];
}

class SubscribedTopicsLoaded extends SubscriptionEvent {}

class TopicAdded extends SubscriptionEvent {
  final Topic topic;

  const TopicAdded(this.topic);

  @override
  List<Object> get props => [topic];

  @override
  String toString() => 'TopicAdded { topic: $topic }';
}

class TopicDeleted extends SubscriptionEvent {
  final Topic topic;

  const TopicDeleted(this.topic);

  @override
  List<Object> get props => [topic];

  @override
  String toString() => 'TopicAdded { topic: $topic }';
}
