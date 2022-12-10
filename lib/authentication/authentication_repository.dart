import 'package:assistantpro/authentication/exception_errors/password_reset_exceptions.dart';
import 'package:assistantpro/src/features/authentication/screens/login_screen.dart';
import 'package:assistantpro/src/features/home_page/screens/home_page_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'exception_errors/signin_email_password_exceptions.dart';
import 'exception_errors/signup_email_password_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //vars
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> fireUser;
  bool isUserLoggedIn = false;
  var verificationId = ''.obs;
  GoogleSignIn? googleSignIn;
  @override
  void onReady() {
    fireUser = Rx<User?>(_auth.currentUser);
    if (fireUser.value != null) {
      isUserLoggedIn = true;
    }
    fireUser.bindStream(_auth.userChanges());
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (fireUser.value != null) {
        Get.offAll(() => const HomePageScreen());
        isUserLoggedIn = true;
        return 'success';
      }
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
      if (fireUser.value != null) {
        Get.offAll(() => const HomePageScreen());
        isUserLoggedIn = true;
        return 'success';
      }
    } on FirebaseAuthException catch (e) {
      final ex = SignInWithEmailAndPasswordFailure.code(e.code);
      if (kDebugMode) print('FIREBASE AUTH EXCEPTION : ${ex.errorMessage}');
      return ex.errorMessage;
    } catch (_) {}
    return 'default/failed';
  }

  Future<String> signInWithPhoneNumber(String phoneNumber) async {
    String returnMessage = 'codeSent';
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (credential) async {
            final auth = await _auth.signInWithCredential(credential);
            if (auth.user != null) {
              Get.offAll(() => const HomePageScreen());
            }
          },
          verificationFailed: (e) {
            returnMessage = e.code;
          },
          codeSent: (verificationId, resendToken) {
            this.verificationId.value = verificationId;
          },
          codeAutoRetrievalTimeout: (verificationId) {
            this.verificationId.value = verificationId;
          });
    } on FirebaseAuthException catch (e) {
      returnMessage = e.code;
    } catch (e) {
      returnMessage = e.toString();
    }

    return returnMessage;
  }

  Future<String> verifyOTP(String otp) async {
    UserCredential credentials;
    try {
      credentials = await _auth.signInWithCredential(
          PhoneAuthProvider.credential(
              verificationId: verificationId.value, smsCode: otp));
      if (credentials.user != null) {
        return 'success';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code.compareTo('invalid-verification-code') == 0) {
        return 'wrongOTP'.tr;
      }
    } catch (_) {}

    return 'unknownError'.tr;
  }

  Future<String> signInWithGoogle() async {
    try {
      googleSignIn = kIsWeb
          ? GoogleSignIn(
              clientId:
                  '115591952018-55tds54bjplo4hdc4ocsea6j1em048td.apps.googleusercontent.com')
          : GoogleSignIn();
      final googleSignInAccount = await googleSignIn?.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication? signInAuthentication =
            await googleSignInAccount.authentication;

        AuthCredential credential = GoogleAuthProvider.credential(
          idToken: signInAuthentication.idToken,
          accessToken: signInAuthentication.accessToken,
        );
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          Get.offAll(() => const HomePageScreen());
          return 'success';
        }
      }
    } catch (e) {
      if (kDebugMode) e.printError();
    }
    return 'failedGoogleAuth'.tr;
  }

  Future<String> resetPassword({required String email}) async {
    String returnMessage = 'unknownError'.tr;
    try {
      await _auth
          .sendPasswordResetEmail(email: email)
          .then((value) => returnMessage = 'emailSent');
    } on FirebaseAuthException catch (e) {
      final ex = ResetPasswordFailure.code(e.code);
      if (kDebugMode) print('FIREBASE AUTH EXCEPTION : ${ex.errorMessage}');
      return ex.errorMessage;
    } catch (_) {}
    return returnMessage;
  }

  Future<void> logoutUser() async {
    await Get.offAll(() => const LoginScreen());
    await _auth.signOut();
    await googleSignIn?.signOut();
  }
}
