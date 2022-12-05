import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

// connection states for easy identification
enum MqttCurrentConnectionState {
  idle,
  connecting,
  connected,
  disconnected,
  errorWhenConnecting
}

enum MqttSubscriptionState { idle, subscribed }

class MQTTClientServerWrapper {
  late MqttServerClient client;

  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.idle;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.idle;

  // using async tasks, so the connection won't hinder the code flow
  Future<void> prepareMqttClient() async {
    _setupMqttClient();
    await _connectClient();
    _subscribeToTopic('networks');
    // _publishMessage('Hello');
  }

  // waiting for the connection, if an error occurs, print it and disconnect
  Future<void> _connectClient() async {
    try {
      if (kDebugMode) print('client connecting....');

      connectionState = MqttCurrentConnectionState.connecting;
      await client.connect('alyamgad', 'SS@207&Style6');
    } on Exception catch (e) {
      if (kDebugMode) print('client exception - $e');
      connectionState = MqttCurrentConnectionState.errorWhenConnecting;
      client.disconnect();
    }

    // when connected, print a confirmation, else print an error
    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.connected;
      if (kDebugMode) print('client connected');
    } else {
      if (kDebugMode) {
        print(
            'ERROR client connection failed - disconnecting, status is ${client.connectionStatus}');
      }

      connectionState = MqttCurrentConnectionState.errorWhenConnecting;
      client.disconnect();
    }
  }

  void _setupMqttClient() {
    client = MqttServerClient.withPort(
        'e5632b826dc54150a9ade8771b6a0db5.s2.eu.hivemq.cloud',
        'flutter client',
        8883);
    // the next 2 lines are necessary to connect with tls, which is used by HiveMQ Cloud
    client.secure = true;
    client.securityContext = SecurityContext.defaultContext;
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
  }

  void _subscribeToTopic(String topicName) {
    if (kDebugMode) print('Subscribing to the $topicName topic');
    client.subscribe(topicName, MqttQos.atMostOnce);

    // print the message when it is received
    client.updates?.listen((List<MqttReceivedMessage> c) {
      final MqttPublishMessage recMess = c[0].payload;
      var message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      if (kDebugMode) print('YOU GOT A NEW MESSAGE:');
      if (kDebugMode) print(message);
    });
  }

  void _publishMessage(String message) {
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    final builderPayload = builder.payload;
    if (kDebugMode) {
      print('Publishing message "$message" to topic ${'networks'}');
    }
    client.publishMessage('networks', MqttQos.exactlyOnce, builderPayload!);
  }

  // callbacks for different events
  void _onSubscribed(String topic) {
    if (kDebugMode) print('Subscription confirmed for topic $topic');
    subscriptionState = MqttSubscriptionState.subscribed;
  }

  void _onDisconnected() {
    if (kDebugMode) {
      print('OnDisconnected client callback - Client disconnection');
    }
    connectionState = MqttCurrentConnectionState.disconnected;
  }

  void _onConnected() {
    connectionState = MqttCurrentConnectionState.connected;
    if (kDebugMode) {
      print('OnConnected client callback - Client connection was successful');
    }
  }
}
