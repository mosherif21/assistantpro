import 'package:assistantpro/src/features/authentication/screens/login_screen.dart';
import 'package:assistantpro/src/features/home_page/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'exception_errors/signin_email_password_exceptions.dart';
import 'exception_errors/signup_email_password_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //vars
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> fireUser;
  bool isUserLoggedIn = false;
  var verificationId = ''.obs;
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

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (fireUser.value != null) Get.offAll(() => const HomePage());
      isUserLoggedIn = true;
      return 'success';
    } on FirebaseAuthException catch (e) {
      final ex = SignInWithEmailAndPasswordFailure.code(e.code);
      if (kDebugMode) print('FIREBASE AUTH EXCEPTION : ${ex.errorMessage}');
      return ex.errorMessage;
    } catch (_) {}
    return 'default/failed';
  }

  Future<String> signInWithPhoneNumber(String phoneNumber) async {
    String returnMessage = 'codeSent';
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) async {
          await _auth.signInWithCredential(credential);
          Get.offAll(() => const HomePage());
        },
        verificationFailed: (e) {
          if (e.code.compareTo('invalid-phone-number') == 0) {
            returnMessage = 'Phone number is not valid';
          }
        },
        codeSent: (verificationId, resendToken) {
          this.verificationId.value = verificationId;
        },
        codeAutoRetrievalTimeout: (verificationId) {
          this.verificationId.value = verificationId;
        });
    return returnMessage;
  }

  Future<String> verifyOTP(String otp) async {
    UserCredential credentials;
    try {
      credentials = await _auth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: verificationId.value, smsCode: otp));
      if (credentials.user != null) return 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code.compareTo('invalid-verification-code') == 0) {
        return 'Entered OTP is wrong';
      }
    } catch (_) {}

    return 'Unknown error occurred';
  }

  Future<void> signInWithGoogle(String email, String password) async {}

  Future<void> logoutUser() async {
    await _auth.signOut();
    Get.offAll(() => const LoginScreen());
  }
}
