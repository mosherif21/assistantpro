//import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

Future<void> initializeFireBaseApp() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> activateWebAppCheck() async {
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: '6LefC1ojAAAAAHL8YHmKcleLaWJfZHzsq8VvXA-_',
  );
}

Future<void> activateAndroidAppCheck() async {
  await FirebaseAppCheck.instance.activate(
    // ignore: deprecated_member_use
    androidProvider: AndroidProvider.safetyNet,
  );
}

Future<void> activateIosAppCheck() async {}
