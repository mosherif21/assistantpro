import 'package:assistantpro/src/common_widgets/regular_bottom_sheet.dart';
import 'package:assistantpro/src/constants/common_functions.dart';
import 'package:assistantpro/src/features/authentication/components/resetPassword/email_reset_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common_widgets/framed_button.dart';

class ForgetPasswordLayout extends StatelessWidget {
  const ForgetPasswordLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = getScreenHeight(context);
    return Container(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'chooseForgetPasswordMethod'.tr,
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(height: screenHeight * 0.02),
          FramedIconButton(
            height: screenHeight * 0.12,
            title: 'emailLabel'.tr,
            subTitle: 'emailReset'.tr,
            iconData: Icons.mail_outline_rounded,
            onPressed: () {
              RegularBottomSheet.hideBottomSheet();
              const EmailResetScreen();
            },
          ),
        ],
      ),
    );
  }
}
