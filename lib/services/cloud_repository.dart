// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:mqtt_flutter_bloc/models/models.dart';

// class CloudRepository {
//   @override
//   Future<List<Broker>> getBrokers(String userId, String key) async {
//     final ref = await Firestore.instance
//         .collection('users')
//         .document(userId)
//         .collection('brokers')
//         .document(key)
//         .get();
//     return ref.data;
//   }

//   @override
//   Future<void> deleteBroker(String userId, String key) async {
//     await Firestore.instance
//         .collection('users')
//         .document(userId)
//         .collection('brokers')
//         .document(key)
//         .delete();
//   }

//   @override
//   void addBroker(String userId, String key, Broker broker) async {
//     await Firestore.instance
//         .collection('users')
//         .document(userId)
//         .collection('brokers')
//         .document(key)
//         .setData(broker);
//   }

//   @override
//   Future<List<WidgetItem>> getWidgets(String userId, String key) async {
//     final ref = await Firestore.instance
//         .collection('users')
//         .document(userId)
//         .collection('widgets')
//         .document(key)
//         .get();
//     return ref.data;
//   }

//   @override
//   Future<List<Topic>> getTopics(String userId, String key) async {
//     final ref = await Firestore.instance
//         .collection('users')
//         .document(userId)
//         .collection('topics')
//         .document(key)
//         .get();
//     return ref.data;
//   }

//   @override
//   Future<String> getString(String userId, String key) async {
//     final ref = await Firestore.instance
//         .collection('users')
//         .document(userId)
//         .collection('strings')
//         .document(key)
//         .get();
//     if (ref.data != null) return ref.data['string'] as String;
//     return null;
//   }

//   @override
//   Future<void> removeObject(String userId, String key) async {
//     await Firestore.instance
//         .collection('users')
//         .document(userId)
//         .collection('objects')
//         .document(key)
//         .delete();
//   }

//   @override
//   Future<void> removeString(String userId, String key) async {
//     await Firestore.instance
//         .collection('users')
//         .document(userId)
//         .collection('strings')
//         .document(key)
//         .delete();
//     return null;
//   }

//   @override
//   void saveObject(
//       String userId, String key, Map<String, dynamic> object) async {
//     await Firestore.instance
//         .collection('users')
//         .document(userId)
//         .collection('objects')
//         .document(key)
//         .setData(object);
//   }

//   @override
//   void saveString(String userId, String key, String value) async {
//     await Firestore.instance
//         .collection('users')
//         .document(userId)
//         .collection('strings')
//         .document(key)
//         .setData({'string': value});
//   }
// }
