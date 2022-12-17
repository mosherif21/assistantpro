import 'package:assistantpro/src/connectivity/connectivity_controller.dart';
import 'package:assistantpro/src/constants/app_init_constants.dart';
import 'package:assistantpro/src/constants/common_functions.dart';
import 'package:assistantpro/src/features/authentication/screens/login_screen.dart';
import 'package:assistantpro/src/features/home_page/screens/home_page_screen.dart';
import 'package:assistantpro/src/features/onboarding/screens/on_boarding_screen.dart';
import 'package:assistantpro/src/routing/splash_screen.dart';
import 'package:assistantpro/src/utils/theme/theme.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'authentication/authentication_repository.dart';
import 'localization/language/localization_strings.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a background message: ${message.data['title']}");
  }
  AwesomeNotifications().createNotificationFromJsonData(message.data);
}

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await AppInit.initializeConstants();
  Get.put(ConnectivityController());
  final internetConnectionStatus =
      await InternetConnectionCheckerPlus().connectionStatus;
  if (internetConnectionStatus == InternetConnectionStatus.connected) {
    await AppInit.initialize();
    Get.put(AuthenticationRepository());
  }
  if (AuthenticationRepository.instance.isUserLoggedIn) {
    await initializeMqttClient();
  }
  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'assistantpro',
        channelName: 'assistantpro notifications',
        channelDescription: 'Notification channel for assistantpro',
        defaultColor: Colors.black,
        ledColor: Colors.white)
  ]);
  final messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  if (kDebugMode) {
    print('User granted permission: ${settings.authorizationStatus}');
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (kDebugMode) {
      print("Handling a foreground message: ${message.data['title']}");
    }
    AwesomeNotifications().createNotificationFromJsonData(message.data);
  });

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
          home: AppInit.showOnBoard
              ? const OnBoardingScreen()
              : AuthenticationRepository.instance.isUserLoggedIn
                  ? const HomePageScreen()
                  : const LoginScreen(),
        );
      },
      maximumSize: const Size(500.0, 812.0),
      enabled: AppInit.notWebMobile,
      backgroundColor: Colors.white,
    );
  }
}
