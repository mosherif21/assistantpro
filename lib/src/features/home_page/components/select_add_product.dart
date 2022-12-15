import 'package:assistantpro/src/common_widgets/regular_bottom_sheet.dart';
import 'package:assistantpro/src/features/home_page/components/product_data_form.dart';
import 'package:assistantpro/src/features/home_page/components/qr_code_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common_widgets/framed_button.dart';

class ChooseAddDeviceMethod extends StatelessWidget {
  const ChooseAddDeviceMethod({Key? key, required this.screenHeight})
      : super(key: key);
  final double screenHeight;
  @override
  Widget build(BuildContext context) {
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
            onPressed: () {
              RegularBottomSheet.hideBottomSheet();
              Get.to(() => const QRScannerWidget());
            },
          ),
          SizedBox(height: screenHeight * 0.02),
          FramedIconButton(
            height: screenHeight * 0.12,
            title: 'productId'.tr,
            subTitle: 'addProductId'.tr,
            iconData: Icons.password,
            onPressed: () {
              RegularBottomSheet.hideBottomSheet();
              Get.to(
                () => ProductDataForm(
                  productId: '',
                  productName: '',
                  buttonText: 'registerDevice'.tr,
                  qrCodeAdd: false,
                  getTopic: '',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
