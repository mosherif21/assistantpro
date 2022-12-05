import 'package:assistantpro/src/constants/common_functions.dart';
import 'package:assistantpro/src/constants/sizes.dart';
import 'package:assistantpro/src/features/authentication/controllers/otp_verification_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../../constants/app_init_constants.dart';

final RxBool _confirmButtonEnable = false.obs;

class OTPVerificationScreen extends StatelessWidget {
  const OTPVerificationScreen(
      {Key? key,
      required this.verificationType,
      required this.lottieAssetAnim,
      required this.enteredString,
      required this.inputType,
      required this.inputOperation})
      : super(key: key);
  final String verificationType;
  final String lottieAssetAnim;
  final String enteredString;
  final InputType inputType;
  final InputOperation inputOperation;

  @override
  Widget build(BuildContext context) {
    double? screenHeight = getScreenHeight(context);
    //String verificationCode = '';

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPaddingSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              lottieAssetAnim,
              fit: BoxFit.contain,
              height: screenHeight * 0.5,
            ),
            Text(
              AppInit.currentDeviceLanguage == Language.english
                  ? '$verificationType ${'verificationCode'.tr}'
                  : '${'verificationCode'.tr} $verificationType',
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: AppInit.notWebMobile ? 25 : 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              enteredString,
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              'verificationCodeShare'.tr,
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 20.0,
            ),
            OtpTextField(
              numberOfFields: 6,
              borderColor: Colors.black54,
              keyboardType: TextInputType.number,
              cursorColor: Colors.white,
              focusedBorderColor: Colors.white,
              showFieldAsBox: false,
              textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w600),
              borderWidth: 4.0,
              // onCodeChanged: (code) {
              //   _confirmButtonEnable.value = false;
              // },
              onSubmit: (enteredVerificationCode) async {
                _confirmButtonEnable.value = true;
                await OtpVerificationController.instance.verifyOTP(
                    verificationCode: enteredVerificationCode,
                    inputType: inputType,
                    inputOperation: inputOperation);
              },
            ),
            // const SizedBox(
            //   height: 30.0,
            // ),
            // SizedBox(
            //   width: double.infinity,
            //   height: screenHeight * 0.05,
            //   child: Obx(
            //     () => ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //         elevation: 0,
            //         backgroundColor: Colors.black,
            //         foregroundColor: Colors.white,
            //         shape: const RoundedRectangleBorder(
            //           borderRadius: BorderRadius.all(
            //             Radius.circular(3),
            //           ),
            //         ),
            //       ),
            //       onPressed: _confirmButtonEnable.value
            //           ? () async => verifyOTP()
            //           : null,
            //       child: Text(
            //         'confirm'.tr,
            //         style: const TextStyle(
            //             color: Colors.white, fontWeight: FontWeight.w500),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
