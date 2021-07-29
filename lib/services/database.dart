import 'package:mqtt_flutter_bloc/models/models.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();

  //static = only a single copy of _db is shared among all the instances of this class (Database)
  static Database _database;

  //Future<Database> get database async => _database ??= await createDatabase();
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  Future<Database> createDatabase() async {
    final path = join(await getDatabasesPath(), 'mqtt.db');
    final database = await openDatabase(path,
        version: 1, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  void initDB(Database db, int version) async {
    await db.execute('''
        CREATE TABLE widgets(
          id INTEGER PRIMARY KEY, 
          name TEXT, 
          topic TEXT, 
          pubTopic TEXT, 
          type TEXT, 
          payload TEXT, 
          jsonPath TEXT)
          ''');
    await db.execute('''
        CREATE TABLE brokers(
          id INTEGER PRIMARY KEY, 
          name TEXT, 
          address TEXT, 
          port INTEGER, 
          username TEXT, 
          password TEXT, 
          identifier TEXT, 
          secure INTEGER, 
          qos INTEGER, 
          certificatePath TEXT, 
          privateKeyPath TEXT, 
          privateKeyPassword TEXT, 
          clientAuthorityPath TEXT, 
          state TEXT)
          ''');
    await db.execute('''
          CREATE TABLE topics(
            id INTEGER PRIMARY KEY,
            brokerId INTEGER, 
            title TEXT)
            ''');
  }

  Future<void> cleanDatabase() async {
    try {
      final db = await dbProvider.database;
      db.delete('brokers');
      db.delete('topics');
      db.delete('widgets');
    } catch (error) {
      throw Exception('CleanDatabase: ${error.toString()}');
    }
  }

  // Future<void> cleanDatabase() async {
  //   try {
  //     final db = await dbProvider.database;
  //     await db.transaction((txn) async {
  //       var batch = txn.batch();
  //       batch.delete('brokers');
  //       batch.delete('topics');
  //       batch.delete('widgets');
  //       await batch.commit();
  //     });
  //   } catch (error) {
  //     throw Exception('CleanDatabase: ${error.toString()}');
  //   }
  // }

  Future<int> getCount() async {
    Database db = await dbProvider.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM brokers'));
  }

  Future<List<Broker>> getBrokers() async {
    Database db = await dbProvider.database;
    List<Map> list = await db.rawQuery('SELECT * FROM brokers');
    return list.map((brokers) => Broker.fromMap(brokers)).toList();
  }
}
