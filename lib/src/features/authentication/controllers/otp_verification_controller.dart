import 'package:assistantpro/authentication/authentication_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../constants/app_init_constants.dart';
import '../../../routing/loading_screen.dart';
import '../../home_page/screens/home_page.dart';
import '../components/resetPassword/make_new_password_screen.dart';

class OtpVerificationController extends GetxController {
  static OtpVerificationController get instance => Get.find();
  final enteredData = TextEditingController();

  Future<String> signInWithOTPPhone(
      String phoneNumber, InputOperation inputOperation) async {
    String returnMessage;
    if (phoneNumber.length == 13) {
      returnMessage = await AuthenticationRepository.instance
          .signInWithPhoneNumber(phoneNumber, inputOperation);
    } else {
      returnMessage = 'Please enter a valid phone number';
    }
    return returnMessage;
  }

  Future<String> verifyOTPPhone(String otp) async {
    var returnMessage = await AuthenticationRepository.instance.verifyOTP(otp);
    return returnMessage;
  }

  Future<String> verifyOTPEmail(String otp) async {
    var returnMessage = await AuthenticationRepository.instance.verifyOTP(otp);
    return returnMessage;
  }

  Future<void> verifyOTP(
      {required String verificationCode,
      required InputType inputType,
      required InputOperation inputOperation}) async {
    showLoadingScreen();
    var returnMessage = inputType == InputType.phone
        ? await OtpVerificationController.instance
            .verifyOTPPhone(verificationCode)
        : await OtpVerificationController.instance
            .verifyOTPEmail(verificationCode);
    if (returnMessage.compareTo('success') == 0) {
      inputOperation == InputOperation.signIn
          ? Get.offAll(() => const HomePage())
          : Get.offAll(() => const EnterNewPasswordScreen());
    } else {
      Get.snackbar('Error', returnMessage);
    }
    hideLoadingScreen();
  }
}
