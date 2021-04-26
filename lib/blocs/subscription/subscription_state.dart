import 'package:equatable/equatable.dart';

import '../../models/models.dart';

abstract class SubscriptionState extends Equatable {
  const SubscriptionState();

  @override
  List<Object> get props => [];
}

class SubscribedTopicsInProgress extends SubscriptionState {}

class SubscribedTopicsLoadSuccess extends SubscriptionState {
  final List<Topic> topics;
  final List<String> topicTitles;
  const SubscribedTopicsLoadSuccess(this.topics, this.topicTitles);

  @override
  List<Object> get props => [topics];
}

class SubscribedTopicsFailure extends SubscriptionState {
  final Error error;
  const SubscribedTopicsFailure({this.error});
}
