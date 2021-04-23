import '../models/models.dart';
import 'database.dart';

class TopicRepository {
  final LocalTopicProvider _topicProvider = LocalTopicProvider();

  // Future<List<Topic>> getTopics(int brokerId) =>
  //     _topicProvider.getTopics(brokerId);
  Future<List<Topic>> getTopics() => _topicProvider.getTopics();
  Future<List<String>> getTopicsTitle() => _topicProvider.getTopicsTitle();
  Future addTopic(Topic data) => _topicProvider.addTopic(data);
  Future updateTopic(Topic data) => _topicProvider.updateTopic(data);
  Future deleteTopic(int topicId) => _topicProvider.deleteTopic(topicId);
}

class LocalTopicProvider {
  final dbProvider = DatabaseProvider.dbProvider;

  Future addTopic(Topic topic) async {
    final _db = await dbProvider.database;
    var topicId = _db.insert('topics', topic.toMap());
    return topicId;
  }

  Future deleteTopic(int topicId) async {
    final _db = await dbProvider.database;
    await _db.rawDelete("DELETE FROM topics WHERE id = '$topicId'");
  }

  Future<List<Topic>> getTopics() async {
    final _db = await dbProvider.database;
    List<Map<String, dynamic>> topicMap = await _db.query("topics");
    return List.generate(topicMap.length, (index) {
      return Topic(
          id: topicMap[index]['id'],
          brokerId: topicMap[index]['brokerId'],
          title: topicMap[index]['title']);
    });
  }

  Future<List<String>> getTopicsTitle() async {
    final _db = await dbProvider.database;
    List<Map<String, dynamic>> topicTitleMap =
        await _db.rawQuery('SELECT title FROM topics');
    return List.generate(topicTitleMap.length, (index) {
      return topicTitleMap[index]['title'];
    });
  }

  // Future<List<Topic>> getTopics(int brokerId) async {
  //   final _db = await dbProvider.database;
  //   List<Map<String, dynamic>> topicMap =
  //       await _db.rawQuery("SELECT * FROM topics WHERE brokerId = $brokerId");
  //   return List.generate(topicMap.length, (index) {
  //     return Topic(
  //         id: topicMap[index]['id'],
  //         brokerId: topicMap[index]['brokerId'],
  //         title: topicMap[index]['title']);
  //   });
  // }

  Future updateTopic(Topic topic) async {
    final _db = await dbProvider.database;
    return await _db.update('topics', topic.toJson(),
        where: "id = ?", whereArgs: [topic.id]);
  }
}
