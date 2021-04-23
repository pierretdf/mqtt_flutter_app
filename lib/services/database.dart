import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  createDatabase() async {
    String path = join(await getDatabasesPath(), "mqtt.db");
    var database = await openDatabase(path,
        version: 1, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  void initDB(Database db, int version) async {
    await db.execute(
        "CREATE TABLE widgets(id INTEGER PRIMARY KEY, name TEXT, topic TEXT, pubTopic TEXT, type TEXT, payload TEXT, jsonPath TEXT)");
    await db.execute(
        "CREATE TABLE brokers(id INTEGER PRIMARY KEY, name TEXT, address TEXT, port INTEGER, username TEXT, password TEXT, identifier TEXT, secure INT, qos INT, certificatePath TEXT, privateKeyPath TEXT, privateKeyPassword TEXT, clientAuthorityPath TEXT, state TEXT)");
    await db.execute(
        "CREATE TABLE topics(id INTEGER PRIMARY KEY, brokerId INTEGER, title TEXT)");
  }
}
