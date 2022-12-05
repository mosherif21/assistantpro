import 'package:assistantpro/src/constants/app_init_constants.dart';
import 'package:assistantpro/src/features/authentication/screens/login_screen.dart';
import 'package:assistantpro/src/features/home_page/screens/home_page.dart';
import 'package:assistantpro/src/features/onboarding/screens/on_boarding_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'exception_errors/signup_email_password_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //vars
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> fireUser;
  @override
  void onReady() {
    fireUser = Rx<User?>(_auth.currentUser);
    fireUser.bindStream(_auth.userChanges());
    ever(fireUser, (callback) => _initialScreen);
  }

  _initialScreen(User? user) {
    user == null
        ? AppInit.showOnBoard
            ? Get.offAll(() => const OnBoardingScreen())
            : Get.offAll(() => const LoginScreen())
        : Get.offAll(() => const HomePage());
  }

  Future<void> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      fireUser.value != null
          ? Get.offAll(() => const HomePage())
          : Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      if (kDebugMode) print('FIREBASE AUTH EXCEPTION : ${ex.errorMessage}');
      throw ex;
    } catch (_) {}
  }

  Future<void> signInUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      // final ex = SignInWithEmailAndPasswordFailure.code(e.code);
      // if (kDebugMode) print('FIREBASE AUTH EXCEPTION : ${ex.errorMessage}');
      // throw ex;
    } catch (_) {}
  }

  Future<void> logoutUser() async => await _auth.signOut();
}
