import 'package:assistantpro/src/common_widgets/regular_elevated_button.dart';
import 'package:assistantpro/src/constants/app_init_constants.dart';
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
              inputType: InputType.email,
              initialText: '',
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
            Obx(
              () => controller.returnMessage.value.compareTo('success') != 0
                  ? Text(
                      controller.returnMessage.value,
                      style: const TextStyle(color: Colors.red),
                    )
                  : const SizedBox(),
            ),
            const SizedBox(height: 6),
            RegularElevatedButton(
              buttonText: 'registerTextTitle'.tr,
              height: height,
              enabled: true,
              onPressed: () async {
                await controller.registerNewUser(
                  controller.email.text,
                  controller.password.text,
                  controller.passwordConfirm.text,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
