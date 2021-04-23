import '../models/models.dart';
import 'database.dart';

class WidgetRepository {
  final LocalWidgetProvider _widgetProvider = LocalWidgetProvider();

  Future<List<WidgetItem>> getWidgetItems() => _widgetProvider.getWidgetItems();
  Future<int> addWidgetItem(WidgetItem data) =>
      _widgetProvider.addWidgetItem(data);
  Future<int> updateWidgetItem(WidgetItem data) =>
      _widgetProvider.updateWidgetItem(data);
  Future<void> deleteWidgetItem(int widgetItemId) =>
      _widgetProvider.deleteWidgetItem(widgetItemId);
}

class LocalWidgetProvider {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> addWidgetItem(WidgetItem widgetItem) async {
    final _db = await dbProvider.database;
    var widgetItemId = _db.insert('widgets', widgetItem.toMap());
    return widgetItemId;
  }

  Future<int> updateWidgetItem(WidgetItem widgetItem) async {
    final _db = await dbProvider.database;
    var result = await _db.update('widgets', widgetItem.toJson(),
        where: "id = ?", whereArgs: [widgetItem.id]);
    return result;
  }

  Future<List<WidgetItem>> getWidgetItems() async {
    final _db = await dbProvider.database;
    List<Map<String, dynamic>> widgetItemMap = await _db.query('widgets');
    return List.generate(widgetItemMap.length, (index) {
      return WidgetItem(
          id: widgetItemMap[index]['id'],
          name: widgetItemMap[index]['name'],
          topic: widgetItemMap[index]['topic'],
          pubTopic: widgetItemMap[index]['pubTopic'],
          type: widgetItemMap[index]['type'],
          payload: widgetItemMap[index]['payload'],
          jsonPath: widgetItemMap[index]['jsonPath']);
    });
  }

  Future<void> deleteWidgetItem(int id) async {
    final _db = await dbProvider.database;
    await _db.rawDelete("DELETE FROM widgets WHERE id = '$id'");
  }
}
