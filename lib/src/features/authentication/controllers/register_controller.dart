import 'package:assistantpro/authentication/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  static RegisterController get instance => Get.find();
  final email = TextEditingController();
  final password = TextEditingController();
  final passwordConfirm = TextEditingController();
  RxString returnMessage = ''.obs;

  Future<void> registerNewUser(
      String email, String password, String passwordConfirm) async {
    if (kDebugMode) {
      print('email register data is: email: $email and password: $password');
    }
    if (password.compareTo(passwordConfirm) == 0 && password.length >= 8) {
      returnMessage.value = await AuthenticationRepository.instance
          .createUserWithEmailAndPassword(email, password);
    } else if (email.isEmpty || password.isEmpty || passwordConfirm.isEmpty) {
      returnMessage.value = 'Fields can\'t be empty';
    } else if (password.length < 8) {
      returnMessage.value = 'Password can\'t be less than 8 characters';
    } else {
      returnMessage.value = 'Passwords doesn\'t match';
    }
  }
}
