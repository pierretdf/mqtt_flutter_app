// import 'dart:io';

// import 'package:device_info/device_info.dart';
// import 'package:mqtt_flutter_bloc/models/models.dart';

// class Storage {
//   User _user;
//   String _deviceId;

//   set user(User user) {
//     _user = user;
//     if (_user != null) {
//       //restoreCart();
//       // restore brokersItems, widgets and topics saved
//     }
//   }

//   final Repository _repository;

//   static Future<Storage> create({Repository repository}) async {
//     final ret = Storage(repository);
//     ret.user = await ret.getUser();

//     return ret;
//   }

//   User get user => _user;

//   Storage(this._repository, [User user]) {
//     _cart = Cart();
//     _user = user;
//   }

//   Future<String> deviceId() async {
//     final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     var deviceId = '';
//     if (Platform.isAndroid) {
//       final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//       deviceId = androidInfo.androidId;
//     } else {
//       final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
//       deviceId = iosInfo.identifierForVendor;
//     }
//     return deviceId;
//   }

//   void saveUser(User user) async {
//     _deviceId = await deviceId();

//     await _repository.saveString(_deviceId, 'user.name', user.name);
//     await _repository.saveString(_deviceId, 'user.id', user.id);

//     _user = user;
//   }

//   Future<User> getUser() async {
//     _deviceId = await deviceId();

//     final name = await _repository.getString(_deviceId, 'user.name');
//     final id = await _repository.getString(_deviceId, 'user.id');

//     if (name == null) {
//       return null;
//     }

//     final user = User(name: name, id: id);

//     return user;
//   }

//   void logout() async {
//     _deviceId = await deviceId();

//     await _repository.removeString(_deviceId, 'user.name');
//     await _repository.removeString(_deviceId, 'user.id');

//     _user = null;
//   }
// }
