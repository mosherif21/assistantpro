import 'package:assistantpro/mqtt/mqtt_browser_class.dart';
import 'package:assistantpro/src/connectivity/connectivity_binding.dart';
import 'package:assistantpro/src/constants/app_init_constants.dart';
import 'package:assistantpro/src/features/authentication/screens/login_screen.dart';
import 'package:assistantpro/src/features/onboarding/screens/on_boarding_screen.dart';
import 'package:assistantpro/src/routing/splash_screen.dart';
import 'package:assistantpro/src/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:get/get.dart';

import 'localization/language/localization_strings.dart';
import 'mqtt/mqtt_server_class.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await AppInit.initializeConstants();
  if (AppInit.isWeb) {
    MQTTClientBrowserWrapper newClient = MQTTClientBrowserWrapper();
    await newClient.prepareMqttClient();
  } else {
    MQTTClientServerWrapper newClient = MQTTClientServerWrapper();
    await newClient.prepareMqttClient();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (AppInit.showOnBoard) removeSplashScreen();
    return FlutterWebFrame(
      builder: (context) {
        return GetMaterialApp(
          translations: Languages(),
          locale: AppInit.setLocale,
          fallbackLocale: const Locale('en', 'US'),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          darkTheme: AppTheme.darkTheme,
          initialBinding: ConnectivityBinding(),
          home: AppInit.showOnBoard
              ? const OnBoardingScreen()
              : const LoginScreen(),
        );
      },
      maximumSize: const Size(500.0, 812.0),
      enabled: AppInit.notWebMobile,
      backgroundColor: Colors.white,
    );
  }
}
