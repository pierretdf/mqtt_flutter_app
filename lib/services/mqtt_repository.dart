import 'dart:async';
import 'dart:io';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../models/models.dart';

class MqttRepository {
  final MqttProvider _mqttProvider = MqttProvider();

  Future<MqttServerClient> prepareMqttClient(Broker config) =>
      _mqttProvider.prepareMqttClient(config);
  Future<bool> publishMessage(Message data) =>
      _mqttProvider.publishMessage(data);
  bool subscribeToTopic(String topic) => _mqttProvider.subscribeToTopic(topic);
  void unSubscribeFromTopic(String topic) =>
      _mqttProvider.unSubscribeFromTopic(topic);
  void updateBrokerConfig(Broker config) =>
      _mqttProvider.updateBrokerConfig(config);
  void setupMqttClient() => _mqttProvider.setupMqttClient();
  Future connectClient() => _mqttProvider.connectClient();
  void disconnectClient() => _mqttProvider.disconnectClient();
  int getConnectedBrokerId() => _mqttProvider.getConnectedBrokerId();
  StreamController<Message> streamMessages() => _mqttProvider.streamMessages();
}

class MqttProvider {
  MqttServerClient _client;
  Broker _broker;

  StreamSubscription _subscription;
  final StreamController<Message> _messagesStreamController =
      StreamController<Message>.broadcast();

  Future<MqttServerClient> prepareMqttClient(Broker config) async {
    updateBrokerConfig(config);
    setupMqttClient();
    return connectClient();
  }

  // Call updateConfig if broker is changed
  void updateBrokerConfig(Broker config) {
    _broker = config;
  }

  void setupMqttClient() {
    final connectMessage = MqttConnectMessage()
        .withClientIdentifier(_broker.identifier)
        .keepAliveFor(60) // Must agree with the keep alive set above or not set
        .startClean() // Non persistent session for testing
        .authenticateAs(
          _broker.username,
          _broker.password,
        ) // additional parameters for authenticated broker
        .withWillQos(MqttQos.atMostOnce);

    _client = MqttServerClient(_broker.address, _broker.identifier);
    _client.port = _broker.port;
    _client.logging(on: true);

    // Unsolicited Callbacks
    _client.onDisconnected = _onDisconnected;
    _client.onConnected = _onConnected;
    _client.onSubscribed = _onSubscribed;
    _client.onUnsubscribed = _onUnsubscribed;
    _client.onSubscribeFail = _onSubscribeFail;
    //_client.pongCallback = _pong;

    // Security Context
    _client.secure = _broker.secure;
    if (_broker.secure) {
      final context = SecurityContext()
        ..useCertificateChain(_broker.certificatePath)
        ..usePrivateKey(_broker.privateKeyPath,
            password: _broker.privateKeyPassword)
        ..setClientAuthorities(_broker.clientAuthorityPath);
      _client.securityContext = context;
    }

    _client.connectionMessage = connectMessage;
  }

  Future<bool> _connectToClient() async {
    if (_client != null &&
        _client.connectionStatus.state == MqttConnectionState.connected) {
      print('[MQTT Client] Client already logged in');
      return true;
    } else {
      return await _login() == null ? false : true;
    }
  }

  Future<MqttServerClient> _login() async {
    try {
      await _client.connect();
    } catch (e) {
      print('[MQTT Client] Exception - $e');
      disconnectClient();
      _client = null;
      return _client;
    }
    // Check if broker is connected
    if (_client.connectionStatus.state == MqttConnectionState.connected) {
      print('[MQTT Client] Client connected');
    } else {
      print(
          '[MQTT CLIENT] client connection failed - disconnecting, status is ${_client.connectionStatus}');
      disconnectClient();
      _client = null;
    }
    return _client;
  }

  Future<MqttServerClient> connectClient() async {
    assert(_client != null);
    try {
      print('[MQTT Client] Client connecting....');
      await _client.connect();
    } catch (e) {
      print('[MQTT Client] Exception - $e');
      disconnectClient();
    }

    if (_client.connectionStatus.state == MqttConnectionState.connected) {
      print('[MQTT Client] Client connected');
    } else {
      print(
          '[MQTT Client] Client connection failed - disconnecting, status is ${_client.connectionStatus.state}');
      disconnectClient();
    }
    _subscription = _client.updates.listen(_onMessage);
    return _client;
  }

  void _onMessage(List<MqttReceivedMessage> event) {
    final receivedMsg = event[0].payload as MqttPublishMessage;
    final data =
        MqttPublishPayload.bytesToStringAsString(receivedMsg.payload.message);
    _messagesStreamController.add(Message(
        payload: data,
        topic: event[0].topic,
        qos: receivedMsg.payload.header.qos.index));
  }

  Future<bool> publishMessage(Message message) async {
    if (await _connectToClient() == true) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message.payload);
      print(
          '[MQTT Client] Publish message ${message.payload} to topic ${message.topic}');
      final identifier = _client.publishMessage(
          message.topic, MqttQos.atLeastOnce, builder.payload);
      if (identifier != null) {
        return true;
      }
    }
    return false;
  }

  bool subscribeToTopic(String topic) {
    if (_client.connectionStatus.state == MqttConnectionState.connected) {
      print('[MQTT Client] Subscribing to $topic');
      _client.subscribe(topic, MqttQos.atLeastOnce); //_broker.qos
      // ****Optionnal*****
      // _client.updates.listen((List<MqttReceivedMessage<MqttMessage>> event) {
      //   final MqttPublishMessage receivedMsg = event[0].payload;
      //   final String data = MqttPublishPayload.bytesToStringAsString(
      //       receivedMsg.payload.message);
      //   print('[MQTT Client] Got a message $data');
      // });
      // *************
      return true;
    }
    return false;
  }

  void unSubscribeFromTopic(String topic) {
    print('[MQTT Client] Unsubscribing from $topic');
    _client.unsubscribe(topic);
  }

  void disconnectClient() {
    if (_client.connectionStatus.state == MqttConnectionState.connected) {
      _client.disconnect();
    }
  }

  void _onSubscribed(String topic) =>
      print('[MQTT Client] Subscription confirmed for topic $topic');

  void _onUnsubscribed(String topic) =>
      print('[MQTT Client] Unsubscription confirmed from topic $topic');

  void _onDisconnected() => print(
      '[MQTT Client] OnDisconnected client callback - Client disconnection');

  void _onConnected() {
    print('[MQTT Client] OnConnected client callback - Client connected!');
  }

  void _onSubscribeFail(String topic) =>
      print('[MQTT Client] Failed to subscribe topic: $topic');
  //void _pong() => print('Ping response client callback invoked');

  StreamController<Message> streamMessages() => _messagesStreamController;

  int getConnectedBrokerId() {
    if (_client?.connectionStatus?.state == MqttConnectionState.connected) {
      return _broker.id;
    }
    return null;
  }

  void dispose() {
    _subscription.cancel();
    _messagesStreamController.close();
  }
}
