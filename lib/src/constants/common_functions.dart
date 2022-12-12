import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../mqtt/mqtt_browser_class.dart';
import '../features/home_page/screens/home_page_screen.dart';
import 'app_init_constants.dart';

double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

// ignore: prefer_typing_uninitialized_variables
late final mqttClient;

Future<void> initializeMqttClient() async {
  if (AppInit.isWeb) {
    mqttClient = MQTTClientBrowserWrapper();
    await mqttClient.prepareMqttClient();
  } else {
    // mqttClient = MQTTClientServerWrapper();
    // await mqttClient.prepareMqttClient();
  }
}

void getToHomePage() async {
  Get.offAll(() => const HomePageScreen());
}
