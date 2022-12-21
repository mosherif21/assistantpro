import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';

import '../src/constants/common_functions.dart';

class MQTTProductHandler {
  RxInt countTracker = 0.obs;
  bool subscribed = false;
  final client = mqttClient.client;
  int currentSet = 0;
  Future<void> subscribeToTopic(
      String topicName, String productId, String productName) async {
    if (!subscribed) {
      subscribed = true;
      if (kDebugMode) print('Subscribing to the $topicName topic');
      var subStatus = client.getSubscriptionsStatus(topicName);
      if (subStatus != MqttSubscriptionStatus.active ||
          subStatus != MqttSubscriptionStatus.pending) {
        await client.subscribe(topicName, MqttQos.atMostOnce);
      }

      // print the message when it is received
      client.updates?.listen(
        (List<MqttReceivedMessage> c) {
          final MqttPublishMessage recMess = c[0].payload;
          var message =
              MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
          if (kDebugMode) {
            print('You got a new count');
            print(message);
          }
          countTracker.value = int.parse(message);
        },
      );
    }
  }

  void setCurrentQuantity(String currentQuantity, String topicName) {
    int currentQuantitySet = int.parse(currentQuantity);
    if (currentQuantitySet != currentSet) {
      currentSet = currentQuantitySet;
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(currentQuantity);
      if (kDebugMode) {
        print('Publishing message "$currentQuantity" to topic $topicName');
      }
      client.publishMessage(topicName, MqttQos.exactlyOnce, builder.payload!);
    }
  }

  Future<void> cancelSubscription(String topicName) async {
    await client.unsubscribe(topicName);
    subscribed = false;
  }
}
