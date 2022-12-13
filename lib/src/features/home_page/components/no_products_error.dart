import 'package:assistantpro/src/constants/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/assets_strings.dart';

class NoProducts extends StatelessWidget {
  const NoProducts({
    Key? key,
    required this.screenHeight,
  }) : super(key: key);
  final double screenHeight;
  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight*0.13,),
            Image(
              image: const AssetImage(kRobotImage),
              height: screenHeight * 0.2,
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              'noDevices'.tr,
              style: TextStyle(
                color: Colors.grey,
                fontSize: screenHeight * 0.025,
                fontFamily: 'Bruno Ace',
              ),
            )
          ],
        ),
      ),
    );
  }
}
