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
  Future<void> registerNewUser(String email, String password) async {
    if (kDebugMode) {
      print('email register data is: email: $email and password: $password');
    }
    returnMessage.value = await AuthenticationRepository.instance
        .createUserWithEmailAndPassword(email, password);
  }
}
