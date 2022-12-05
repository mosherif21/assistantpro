import 'package:assistantpro/src/common_widgets/regular_elevated_button.dart';
import 'package:assistantpro/src/common_widgets/text_form_field.dart';
import 'package:assistantpro/src/constants/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../constants/app_init_constants.dart';
import '../constants/sizes.dart';

class SingleEntryScreen extends StatelessWidget {
  const SingleEntryScreen({
    Key? key,
    required this.title,
    required this.lottieAssetAnim,
    required this.textFormTitle,
    required this.textFormHint,
    required this.buttonTitle,
    required this.prefixIconData,
    required this.onPressed,
    required this.textController,
    required this.inputType,
  }) : super(key: key);
  final String title;
  final String lottieAssetAnim;
  final String textFormTitle;
  final String textFormHint;
  final String buttonTitle;
  final IconData prefixIconData;
  final Function onPressed;
  final InputType inputType;

  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    double screenHeight = getScreenHeight(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPaddingSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              lottieAssetAnim,
              height: screenHeight * 0.5,
            ),
            Text(
              title,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: AppInit.notWebMobile ? 25 : 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormFieldRegular(
              labelText: textFormTitle,
              hintText: textFormHint,
              prefixIconData: prefixIconData,
              textController: textController,
            ),
            const SizedBox(height: 20.0),
            RegularElevatedButton(
                buttonText: buttonTitle,
                height: screenHeight,
                onPressed: onPressed),
          ],
        ),
      ),
    );
  }
}
