import 'package:assistantpro/authentication/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ResetController extends GetxController {
  static ResetController get instance => Get.find();
  final emailController = TextEditingController();

  Future<String> resetPassword(String email) async {
    if (kDebugMode) {
      print('email reset data is: $email');
    }
    return await AuthenticationRepository.instance.resetPassword(email: email);
  }
}
