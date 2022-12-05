import 'package:assistantpro/src/connectivity/connectivity_controller.dart';
import 'package:assistantpro/src/constants/app_init_constants.dart';
import 'package:assistantpro/src/features/authentication/screens/login_screen.dart';
import 'package:assistantpro/src/features/onboarding/screens/on_boarding_screen.dart';
import 'package:assistantpro/src/routing/splash_screen.dart';
import 'package:assistantpro/src/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'authentication/authentication_repository.dart';
import 'localization/language/localization_strings.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await AppInit.initializeConstants();
  Get.put(ConnectivityController());
  final internetConnectionStatus =
      await InternetConnectionCheckerPlus().connectionStatus;
  if (internetConnectionStatus == InternetConnectionStatus.connected) {
    AppInit.initialize().then((value) => Get.put(AuthenticationRepository()));
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
