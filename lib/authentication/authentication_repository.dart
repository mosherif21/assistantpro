import 'package:assistantpro/src/features/home_page/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'exception_errors/signup_email_password_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //vars
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> fireUser;
  bool isUserLoggedIn = false;
  @override
  void onReady() {
    fireUser = Rx<User?>(_auth.currentUser);
    if (fireUser.value != null) isUserLoggedIn = true;

    fireUser.bindStream(_auth.userChanges());
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (fireUser.value != null) Get.offAll(() => const HomePage());
      isUserLoggedIn = true;
      return 'success';
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      if (kDebugMode) print('FIREBASE AUTH EXCEPTION : ${ex.errorMessage}');
      return ex.errorMessage;
    } catch (_) {}
    return 'default/failed';
  }

  Future<void> signInUserWithEmailAndPassword(
      String email, String password) async {
    // try {
    //   await _auth.signInWithEmailAndPassword(email: email, password: password);
    // } on FirebaseAuthException catch (e) {
    //   // final ex = SignInWithEmailAndPasswordFailure.code(e.code);
    //   // if (kDebugMode) print('FIREBASE AUTH EXCEPTION : ${ex.errorMessage}');
    //   // throw ex;
    // } catch (_) {}
  }

  Future<void> logoutUser() async => await _auth.signOut();
}
