import 'package:flutter_test/flutter_test.dart';
import 'package:mqtt_flutter_bloc/models/models.dart';
import 'package:mqtt_flutter_bloc/services/database.dart';
import 'package:mqtt_flutter_bloc/services/repositories.dart';

void main() {
  final dbProvider = DatabaseProvider.dbProvider;
  BrokerRepository brokerRepository;
  //MockBrokerRepository mockBrokerRepository;
  Map<String, dynamic> brokerTest = {
    'id': 0,
    'name': 'name',
    'address': 'address',
    'port': 1883,
    'username': 'username',
    'password': 'password',
    'identifier': 'G',
    'secure': 0,
    'qos': 'qos',
    'certificatePath': 'certificatePath',
    'privateKeyPath': 'privateKeyPath',
    'privateKeyPassword': 'privateKeyPassword',
    'clientAuthorityPath': 'clientAuthorityPath',
    'state': 'state'
  };
  setUp(() async {
    // clean up db before every test
    //await dbProvider.cleanDatabase();
  });

  tearDownAll(() async {
    // clean up db after all tests
    //await dbProvider.cleanDatabase();
  });

  group('DBProvider', () {
    test('Insert brokers', () async {
      // at the beginning database is empty
      //expect((await brokerRepository.fetchAllBrokers()), null);

      // insert one empty item
      //brokerRepository.addBroker(Broker.empty());
      expect((await dbProvider.getCount()), 1);

      // insert more empty items
      // brokerRepository.addBroker(Broker.empty());
      // brokerRepository.addBroker(Broker.empty());
      // brokerRepository.addBroker(Broker.empty());
      expect((await dbProvider.getCount()), 1);

      // insert a valid item
      brokerRepository.addBroker(Broker.fromMap(brokerTest));
      expect((await dbProvider.getCount()), 2);
      // insert few times more the same item
      brokerRepository.addBroker(Broker.fromMap(brokerTest));
      brokerRepository.addBroker(Broker.fromMap(brokerTest));
      brokerRepository.addBroker(Broker.fromMap(brokerTest));
      expect((await dbProvider.getCount()), 2);

      // insert other valid items
      brokerRepository.addBroker(Broker.fromMap(brokerTest));
      brokerRepository.addBroker(Broker.fromMap(brokerTest));
      brokerRepository.addBroker(Broker.fromMap(brokerTest));
      expect((await dbProvider.getCount()), 5);
    });

    test('Update brokers', () async {});
    test('Delete brokers', () async {});
    test('Retrieve brokers', () async {});
    test('Delete database', () async {});
  });
}
