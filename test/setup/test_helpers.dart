import 'package:mockito/mockito.dart';
import 'package:mqtt_flutter_bloc/services/repositories.dart';

class MockBrokerRepository extends Mock implements BrokerRepository {}

class MockTopicRepository extends Mock implements TopicRepository {}

class MockMqttRepository extends Mock implements MqttRepository {}
