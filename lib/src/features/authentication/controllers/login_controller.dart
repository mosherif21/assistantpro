import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../authentication/authentication_repository.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();
  final email = TextEditingController();
  final password = TextEditingController();
  RxString returnMessage = ''.obs;
  Future<void> loginUser(String email, String password) async {
    if (email.isEmail && password.length >= 8) {
      returnMessage.value = await AuthenticationRepository.instance
          .signInWithEmailAndPassword(email, password);
    } else if (email.isEmpty || password.isEmpty) {
      returnMessage.value = 'Fields can\'t be empty';
    } else if (password.length < 8) {
      returnMessage.value = 'Password can\'t be less than 8 characters';
    } else {
      returnMessage.value = 'Email  is not in a correct format';
    }
    if (kDebugMode) {
      print('login data is: email: $email and password: $password');
      print(returnMessage.value);
    }
  }
}
