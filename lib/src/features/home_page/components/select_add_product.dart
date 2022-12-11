import 'package:assistantpro/src/common_widgets/regular_bottom_sheet.dart';
import 'package:assistantpro/src/constants/common_functions.dart';
import 'package:assistantpro/src/features/home_page/components/product_data_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../common_widgets/framed_button.dart';

class ChooseAddDeviceMethod extends StatelessWidget {
  const ChooseAddDeviceMethod({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = getScreenHeight(context);
    return Container(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'chooseAddProduct'.tr,
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(height: screenHeight * 0.02),
          FramedIconButton(
            height: screenHeight * 0.12,
            title: 'qrCode'.tr,
            subTitle: 'qrCodeEnter'.tr,
            iconData: Icons.qr_code_scanner,
            onPressed: () {},
          ),
          SizedBox(height: screenHeight * 0.02),
          FramedIconButton(
            height: screenHeight * 0.12,
            title: 'productId'.tr,
            subTitle: 'add using product id',
            iconData: Icons.password,
            onPressed: () {
              RegularBottomSheet.hideBottomSheet();
              Get.to(() => const ProductDataForm());
            },
          ),
        ],
      ),
    );
  }
}
