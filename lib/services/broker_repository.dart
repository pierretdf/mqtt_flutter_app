import '../models/models.dart';
import 'database.dart';

class BrokerRepository {
  final LocalBrokerProvider _brokerProvider = LocalBrokerProvider();

  Future<List<Broker>> getBrokers() => _brokerProvider.getBrokers();
  Future<List<Broker>> fetchAllBrokers() => _brokerProvider.fetchAllBrokers();
  Future<int> addBroker(Broker data) => _brokerProvider.addBroker(data);
  Future<int> updateBroker(Broker data) => _brokerProvider.updateBroker(data);
  Future<void> updateBrokerState(int id, String state) =>
      _brokerProvider.updateBrokerState(id, state);
  Future<void> updateBrokerStateToDisconnected() =>
      _brokerProvider.updateBrokerStateToDisconnected();
  Future<void> deleteBroker(int brokerId) =>
      _brokerProvider.deleteBroker(brokerId);
}

class LocalBrokerProvider {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<List<Broker>> fetchAllBrokers() async {
    final _db = await dbProvider.database;
    final List<Map<String, dynamic>> brokerMap = await _db.query('brokers');
    if (brokerMap.isNotEmpty) {
      return brokerMap.map((map) => Broker.fromMap(map)).toList();
    }
    return null;
  }

  Future<List<Broker>> getBrokers() async {
    final _db = await dbProvider.database;
    final List<Map<String, dynamic>> brokerMap = await _db.query('brokers');
    return List.generate(brokerMap.length, (index) {
      return Broker(
        id: brokerMap[index]['id'],
        name: brokerMap[index]['name'],
        port: brokerMap[index]['port'],
        address: brokerMap[index]['address'],
        username: brokerMap[index]['username'],
        password: brokerMap[index]['password'],
        identifier: brokerMap[index]['identifier'],
        secure: brokerMap[index]['secure'] == 1 ? true : false,
        qos: brokerMap[index]['qos'],
        certificatePath: brokerMap[index]['certificatePath'],
        privateKeyPath: brokerMap[index]['privateKeyPath'],
        privateKeyPassword: brokerMap[index]['privateKeyPassword'],
        clientAuthorityPath: brokerMap[index]['clientAuthorityPath'],
        state: brokerMap[index]['state'],
      );
    });
  }

  Future<void> deleteBroker(int id) async {
    final _db = await dbProvider.database;
    await _db.delete('brokers', where: 'id = ?', whereArgs: [id]);
    await _db.delete('topics', where: 'id = ?', whereArgs: [id]);
    // await _db.rawDelete("DELETE FROM brokers WHERE id = '$id'");
    // await _db.rawDelete("DELETE FROM topics WHERE brokerId = '$id'");
  }

  Future<int> addBroker(Broker broker) async {
    final _db = await dbProvider.database;
    final brokerId = await _db.insert('brokers', broker.toMap());
    return brokerId;
  }

  // Future<int> addBroker(Broker broker) async {
  //   final _db = await dbProvider.database;
  //   //get the biggest id in the table
  //   var table = await _db.rawQuery("SELECT MAX(id)+2 as id FROM brokers");
  //   int id = table.first["id"];
  //   //insert to the table using the new id
  //   var brokerId = await _db.rawInsert(
  //       "INSERT Into brokers (id, name, address, port, username, password, identifier, secure, qos, certificatePath, privateKeyPath, privateKeyPassword, clientAuthorityPath, state)"
  //       " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
  //       [
  //         id,
  //         broker.name,
  //         broker.address,
  //         broker.port,
  //         broker.username,
  //         broker.password,
  //         broker.identifier,
  //         broker.secure,
  //         broker.qos,
  //         broker.certificatePath,
  //         broker.privateKeyPath,
  //         broker.privateKeyPassword,
  //         broker.clientAuthorityPath,
  //         broker.state
  //       ]);
  //   return brokerId;
  // }

  Future<int> updateBroker(Broker broker) async {
    final _db = await dbProvider.database;
    final result = await _db.update('brokers', broker.toMap(),
        where: 'id = ?', whereArgs: [broker.id]);
    return result;
  }

  Future<void> updateBrokerState(int id, String state) async {
    final _db = await dbProvider.database;
    await _db.rawUpdate("UPDATE brokers SET state = '$state' WHERE id = '$id'");
  }

  Future<void> updateBrokerStateToDisconnected() async {
    final _db = await dbProvider.database;
    await _db.rawUpdate(
        "UPDATE brokers SET state = 'disconnected' WHERE state = 'connected'");
  }
}
