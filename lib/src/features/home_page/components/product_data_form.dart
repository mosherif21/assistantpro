import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/regular_elevated_button.dart';
import '../../../common_widgets/text_form_field.dart';
import '../../../constants/app_init_constants.dart';
import '../controllers/product_form_controller.dart';

class ProductDataForm extends StatelessWidget {
  const ProductDataForm({
    Key? key,
    required this.productId,
    required this.productName,
    required this.buttonText,
  }) : super(key: key);
  final String productId;
  final String productName;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductAddController());
    controller.productNameController.text =
        productName.isNotEmpty ? productName : '';
    controller.productIdController.text = productId.isNotEmpty ? productId : '';
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormFieldRegular(
                    labelText: 'productId'.tr,
                    hintText: 'enterProductId'.tr,
                    prefixIconData: Icons.add_circle,
                    textController: controller.productIdController,
                    inputType: InputType.text,
                  ),
                  const SizedBox(height: 10),
                  TextFormFieldRegular(
                    labelText: 'productName'.tr,
                    hintText: 'enterProductName'.tr,
                    prefixIconData: Icons.add_circle,
                    textController: controller.productNameController,
                    inputType: InputType.text,
                  ),
                  const SizedBox(height: 10),
                  TextFormFieldRegular(
                    labelText: 'minQuantity'.tr,
                    hintText: 'enterMinQuantity'.tr,
                    prefixIconData: Icons.add_circle,
                    textController: controller.minimumQuantityController,
                    inputType: InputType.text,
                  ),
                  const SizedBox(height: 10),
                  TextFormFieldRegular(
                    labelText: 'currentQuantity'.tr,
                    hintText: 'enterCurrentQuantity'.tr,
                    prefixIconData: Icons.add_circle,
                    textController: controller.currentQuantityController,
                    inputType: InputType.text,
                  ),
                  const SizedBox(height: 10),
                  TextFormFieldRegular(
                    labelText: 'usageName'.tr,
                    hintText: 'enterUsageName'.tr,
                    prefixIconData: Icons.add_circle,
                    textController: controller.usageLabelController,
                    inputType: InputType.text,
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () =>
                        controller.returnMessage.value.compareTo('success') != 0
                            ? Text(
                                controller.returnMessage.value,
                                style: const TextStyle(color: Colors.red),
                              )
                            : const SizedBox(),
                  ),
                  const SizedBox(height: 10),
                  RegularElevatedButton(
                    buttonText: buttonText,
                    enabled: true,
                    onPressed: () async {
                      final checkSuccess =
                          await controller.registerNewProduct();
                      if (checkSuccess) Get.back();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
