import 'package:assistantpro/src/constants/common_functions.dart';
import 'package:flutter/material.dart';

import '../../../constants/assets_strings.dart';

class NoProducts extends StatelessWidget {
  const NoProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = getScreenHeight(context);
    final screenWidth = getScreenWidth(context);
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage(kRobotImage),
              height: screenHeight * 0.2,
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              'No devices connected',
              style: TextStyle(
                color: Colors.grey,
                fontSize: screenWidth * 0.05,
                fontFamily: 'Bruno Ace',
              ),
            )
          ],
        ),
      ),
    );
  }
}
