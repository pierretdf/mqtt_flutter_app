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
  final List<String> topicsTitle;
  const SubscribedTopicsLoadSuccess(this.topics, this.topicsTitle);

  @override
  List<Object> get props => [topics];
}

class SubscribedTopicsFailure extends SubscriptionState {
  final Error error;
  const SubscribedTopicsFailure(this.error);
}
