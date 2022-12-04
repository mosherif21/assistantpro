import 'package:assistantpro/src/common_widgets/regular_elevated_button.dart';
import 'package:assistantpro/src/features/authentication/controllers/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common_widgets/text_form_field.dart';
import '../../../../common_widgets/text_form_field_passwords.dart';

RxBool passwordHide = true.obs;
RxBool confirmPasswordHide = true.obs;

class EmailRegisterForm extends StatelessWidget {
  const EmailRegisterForm({Key? key, required this.height}) : super(key: key);
  final double height;
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());
    //final formKey = GlobalKey<FormState>();
    return Form(
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormFieldRegular(
              labelText: 'emailLabel'.tr,
              hintText: 'emailHintLabel'.tr,
              prefixIconData: Icons.email_outlined,
              textController: controller.email,
            ),
            const SizedBox(height: 10),
            TextFormFieldPassword(
              labelText: 'passwordLabel'.tr,
              textController: controller.password,
            ),
            const SizedBox(height: 10),
            TextFormFieldPassword(
              labelText: 'confirmPassword'.tr,
              textController: controller.passwordConfirm,
            ),
            const SizedBox(height: 6),
            RegularElevatedButton(
              buttonText: 'registerTextTitle'.tr,
              height: height,
              onPressed: () {
                final email = controller.email.text;
                final password = controller.password.text;
                final passwordConfirm = controller.passwordConfirm.text;
                if (
                    //formKey.currentState!.validate() &&
                    password.compareTo(passwordConfirm) == 0) {
                  RegisterController.instance.registerNewUser(
                    email,
                    password,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
