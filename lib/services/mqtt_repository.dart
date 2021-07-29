import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
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
      _mqttProvider._updateBrokerConfig(config);
  void setupMqttClient() => _mqttProvider._setupMqttClient();
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
    _updateBrokerConfig(config);
    _setupMqttClient();
    return _connectToClient();
  }

  // Call updateConfig if broker is changed
  void _updateBrokerConfig(Broker config) {
    _broker = config;
  }

  void _setupMqttClient() {
    final connectMessage = MqttConnectMessage()
      ..withClientIdentifier(_broker.identifier)
      ..keepAliveFor(60) // Must agree with the keep alive set above or not set
      ..startClean() // Non persistent session for testing
      ..authenticateAs(
        _broker.username,
        _broker.password,
      ) // additional parameters for authenticated broker
      ..withWillQos(MqttQos.atMostOnce);

    _client = MqttServerClient(_broker.address, _broker.identifier);
    _client.port = _broker.port;
    _client.logging(on: true);

    // Unsolicited Callbacks
    _client.onDisconnected = _onDisconnected;
    _client.onConnected = _onConnected;
    _client.onSubscribed = _onSubscribed;
    _client.onUnsubscribed = _onUnsubscribed;
    _client.onSubscribeFail = _onSubscribeFail;

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

  Future<MqttServerClient> _connectToClient() async {
    assert(_client != null);
    try {
      await _client.connect();
    } catch (e) {
      debugPrint('[MQTT Client] Exception - $e');
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
    if (_client.connectionStatus.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message.payload);
      debugPrint(
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
      _client.subscribe(topic, MqttQos.atLeastOnce);
      return true;
    }
    return false;
  }

  void unSubscribeFromTopic(String topic) {
    _client.unsubscribe(topic);
  }

  void disconnectClient() {
    if (_client.connectionStatus.state == MqttConnectionState.connected) {
      _client.disconnect();
    }
  }

  void _onSubscribed(String topic) =>
      debugPrint('[MQTT Client] Subscription confirmed for topic $topic');

  void _onUnsubscribed(String topic) =>
      debugPrint('[MQTT Client] Unsubscription confirmed from topic $topic');

  void _onDisconnected() => debugPrint('[MQTT Client] Client disconnection');

  void _onConnected() => debugPrint('[MQTT Client] Client connected!');

  void _onSubscribeFail(String topic) =>
      debugPrint('[MQTT Client] Failed to subscribe topic: $topic');

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
