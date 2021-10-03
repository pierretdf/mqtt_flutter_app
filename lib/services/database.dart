import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static const _dbName = 'database.db';

  // Use this class as a singleton
  //DatabaseProvider._privateConstructor();

  static final DatabaseProvider dbProvider = DatabaseProvider();

  //static = only a single copy of _database is shared among all the instances of this class (Database)
  static Database _database;

  //Future<Database> get database async => _database ??= await createDatabase();
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  Future<Database> createDatabase() async {
    //Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(path,
        version: 1, onCreate: initDB, onUpgrade: onUpgrade);
  }

  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  Future initDB(Database db, int version) async {
    await db.execute('''
        CREATE TABLE widgets(
          id INTEGER PRIMARY KEY, 
          name TEXT NOT NULL, 
          topic TEXT, 
          pubTopic TEXT, 
          type TEXT, 
          payload TEXT, 
          jsonPath TEXT)
          ''');
    await db.execute('''
        CREATE TABLE brokers(
          id INTEGER PRIMARY KEY, 
          name TEXT NOT NULL, 
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
            brokerId INTEGER NOT NULL, 
            title TEXT)
            ''');
  }

  Future<void> cleanDatabase() async {
    try {
      final db = _database ?? await createDatabase();
      db.delete('brokers');
      db.delete('topics');
      db.delete('widgets');
    } catch (error) {
      throw Exception('CleanDatabase: ${error.toString()}');
    }
  }

  Future<int> getCount() async {
    Database db = await dbProvider.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM brokers'));
  }
}
