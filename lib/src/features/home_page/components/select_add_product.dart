import 'package:assistantpro/src/constants/common_functions.dart';
import 'package:flutter/material.dart';

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
            'choose a way to add the product',
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(height: screenHeight * 0.02),
          FramedIconButton(
            height: screenHeight * 0.12,
            title: 'qr code',
            subTitle: 'add using qr code ',
            iconData: Icons.qr_code_scanner,
            onPressed: () {},
          ),
          SizedBox(height: screenHeight * 0.02),
          FramedIconButton(
            height: screenHeight * 0.12,
            title: 'product id',
            subTitle: 'add using product id',
            iconData: Icons.password,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
