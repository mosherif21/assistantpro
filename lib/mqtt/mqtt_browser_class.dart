import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

// connection states for easy identification
enum MqttCurrentConnectionState {
  idle,
  connecting,
  connected,
  disconnected,
  errorWhenConnecting
}

enum MqttSubscriptionState { idle, subscribed }

class MQTTClientBrowserWrapper {
  late MqttBrowserClient client;
  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.idle;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.idle;

  // using async tasks, so the connection won't hinder the code flow
  Future<void> prepareMqttClient() async {
    _setupMqttClient();
    await _connectClient();
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
    // the next 2 lines are necessary to connect with tls, which is used by HiveMQ Cloud
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    client = MqttBrowserClient.withPort(
        'wss://e5632b826dc54150a9ade8771b6a0db5.s2.eu.hivemq.cloud/mqtt',
        uid!,
        8884);
    client.keepAlivePeriod = 60;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
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
