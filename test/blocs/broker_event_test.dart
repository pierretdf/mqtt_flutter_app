import 'package:flutter_test/flutter_test.dart';
import 'package:mqtt_flutter_bloc/blocs/blocs.dart';

void main() {
  group('BrokerEvent', () {
    group('BrokersLoaded', () {
      test('returns correct props', () {
        expect(BrokersLoaded().props, ['Chicago']);
      });
    });
  });
}
