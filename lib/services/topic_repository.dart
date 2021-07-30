import '../models/models.dart';
import 'database.dart';

class TopicRepository {
  final LocalTopicProvider _topicProvider = LocalTopicProvider();

  Future<List<Topic>> getTopicsByBrokerId(int brokerId) =>
      _topicProvider.getTopicsByBrokerId(brokerId);
  Future<List<Topic>> getTopics() => _topicProvider.getTopics();
  Future<List<String>> getTopicsTitleByBrokerId(int brokerId) =>
      _topicProvider.getTopicsTitleByBrokerId(brokerId);
  Future<List<String>> getTopicsTitle() => _topicProvider.getTopicsTitle();
  Future<int> addTopic(Topic data) => _topicProvider.addTopic(data);
  Future<void> deleteTopic(int topicId) => _topicProvider.deleteTopic(topicId);
  Future<void> deleteTopicByBrokerId(int topicId, int brokerId) =>
      _topicProvider.deleteTopicByBrokerId(topicId, brokerId);
}

class LocalTopicProvider {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<List<Topic>> getTopics() async {
    final _db = await dbProvider.database;
    final List<Map<String, dynamic>> topicMap = await _db.query('topics');
    return List.generate(topicMap.length, (index) {
      return Topic(
          id: topicMap[index]['id'],
          brokerId: topicMap[index]['brokerId'],
          title: topicMap[index]['title']);
    });
  }

  Future<int> addTopic(Topic topic) async {
    final _db = await dbProvider.database;
    final topicId = _db.insert('topics', topic.toMap());
    return topicId;
  }

  Future<void> deleteTopic(int topicId) async {
    final _db = await dbProvider.database;
    await _db.delete('topics', where: 'id = ?', whereArgs: [topicId]);
  }

  Future<List<String>> getTopicsTitle() async {
    final _db = await dbProvider.database;
    final List<Map<String, dynamic>> topicTitleMap =
        await _db.rawQuery('SELECT title FROM topics');
    return List.generate(topicTitleMap.length, (index) {
      return topicTitleMap[index]['title'];
    });
  }

  Future<List<String>> getTopicsTitleByBrokerId(int brokerId) async {
    final _db = await dbProvider.database;
    final List<Map<String, dynamic>> topicTitleMap = await _db
        .rawQuery('SELECT title FROM topics WHERE brokerId = $brokerId');
    return List.generate(topicTitleMap.length, (index) {
      return topicTitleMap[index]['title'];
    });
  }

  Future<List<Topic>> getTopicsByBrokerId(int brokerId) async {
    final _db = await dbProvider.database;
    List<Map<String, dynamic>> topicMap =
        await _db.rawQuery("SELECT * FROM topics WHERE brokerId = $brokerId");
    return List.generate(topicMap.length, (index) {
      return Topic(
          id: topicMap[index]['id'],
          brokerId: topicMap[index]['brokerId'],
          title: topicMap[index]['title']);
    });
  }

  Future<void> deleteTopicByBrokerId(int topicId, int brokerId) async {
    final _db = await dbProvider.database;
    await _db.rawDelete(
        "DELETE FROM topics WHERE id = '$topicId', brokerId = '$brokerId'");
  }
}
