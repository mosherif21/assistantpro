import 'package:assistantpro/src/constants/app_init_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/get.dart';

import '../otpVerification/phone_verification_screen.dart';

class AlternateLoginButtons extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  const AlternateLoginButtons(
      {Key? key, required this.screenHeight, required this.screenWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double buttonsHeight =
        AppInit.notWebMobile ? screenHeight * 0.06 : screenHeight * 0.05;
    double buttonsWidth = screenWidth * 0.85;
    double buttonSpacing = screenHeight * 0.01;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SignInButton(
          Buttons.Phone,
          text: 'loginWithMobile'.tr,
          onPressed: () => getToPhoneVerificationScreen(),
          height: buttonsHeight,
          width: buttonsWidth,
        ),
        SizedBox(height: buttonSpacing),
        SignInButton(
          Buttons.GoogleDark,
          text: 'loginWithGoogle'.tr,
          onPressed: () {},
          height: buttonsHeight,
          width: buttonsWidth,
        ),
        SizedBox(height: buttonSpacing),
        SignInButton(
          Buttons.Facebook,
          text: 'loginWithFacebook'.tr,
          onPressed: () {},
          height: buttonsHeight,
          width: buttonsWidth,
        ),
      ],
    );
  }
}
