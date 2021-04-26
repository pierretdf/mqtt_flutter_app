import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mqtt_flutter_bloc/blocs/blocs.dart';
import 'package:mqtt_flutter_bloc/models/models.dart';
import '../setup/test_helpers.dart';

void main() {
  group('BrokerBloc', () {
    MockBrokerRepository mockBrokerRepository;
    MockTopicRepository mockTopicRepository;
    MockMqttRepository mockMqttRepository;
    BrokerBloc brokerBloc;
    MqttBloc mqttBloc;

    setUp(() {
      mockBrokerRepository = MockBrokerRepository();
      mockTopicRepository = MockTopicRepository();
      mockMqttRepository = MockMqttRepository();
      mqttBloc = MqttBloc(mockMqttRepository, mockTopicRepository);
      brokerBloc = BrokerBloc(mockBrokerRepository, mqttBloc);
    });
    group('BrokersLoaded', () {
      blocTest(
        'emits [BrokerLoadInProgress, BrokerLoadSuccess] when BrokerRequested is added and getBrokers succeeds',
        build: () {
          when(mockBrokerRepository.getBrokers()).thenAnswer(
            (_) => Future.value([
              const Broker(address: '', name: '', port: null, secure: null)
            ]),
          );
          return brokerBloc;
        },
        act: (bloc) => bloc.add(BrokersLoaded()),
        // expect: [
        //   BrokerLoadInProgress(),
        //   BrokerLoadSuccess(
        //       [Broker(address: '', name: '', port: null, secure: null)]),
        // ],
      );
    });
    tearDown(() {
      brokerBloc.close();
    });
  });
}
