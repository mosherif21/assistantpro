import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../mqtt/mqtt_server_class.dart';
import '../features/home_page/screens/home_page_screen.dart';

double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

// ignore: prefer_typing_uninitialized_variables
var mqttClient;

Future<void> initializeMqttClient() async {
  // mqttClient = MQTTClientBrowserWrapper();
  // await mqttClient.prepareMqttClient();

  mqttClient = MQTTClientServerWrapper();
  await mqttClient.prepareMqttClient();
}

void getToHomePage() async {
  Get.offAll(() => const HomePageScreen());
}
