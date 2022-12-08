import 'package:assistantpro/firebase/firebase_manage_data.dart';
import 'package:assistantpro/src/constants/app_init_constants.dart';
import 'package:assistantpro/src/constants/assets_strings.dart';
import 'package:assistantpro/src/constants/common_functions.dart';
import 'package:assistantpro/src/features/home_page/components/no_products_error.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../connectivity/connectivity.dart';
import '../components/assitantpro_product.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConnectivityChecker.checkConnection(true);
    double screenHeight = getScreenHeight(context);
    double screenWidth = getScreenWidth(context);
    final firebaseDataController = FireBaseDataAccess.instance;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: const AssetImage(kLogoImage),
                    height: screenHeight * 0.1,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: screenHeight * 0.027, left: screenWidth * 0.01),
                    child: const Text(
                      'AssistantPro',
                      style: TextStyle(
                          fontFamily: 'Bruno Ace',
                          color: Colors.white,
                          fontSize: 20),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.1),
                  Container(
                    margin: EdgeInsets.only(
                        top: screenHeight * 0.027, left: screenWidth * 0.01),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        AppInit.currentDeviceLanguage == Language.english
                            ? 'ENG'
                            : 'AR',
                        style: const TextStyle(
                            fontFamily: 'Bruno Ace',
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: screenHeight * 0.025,
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: Image(
                        image: const AssetImage(kWebImage),
                        fit: BoxFit.fill,
                        height: screenHeight * 0.05,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Devices",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontFamily: 'Bruno Ace',
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Container(
                    height: screenHeight * 0.6,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: SingleChildScrollView(
                        child: Obx(
                          () => firebaseDataController.userProducts.isNotEmpty
                              ? Column(
                                  children: [
                                    for (var product
                                        in firebaseDataController.userProducts)
                                      Product(
                                        screenHeight: screenHeight,
                                        screenWidth: screenWidth,
                                        product: product,
                                      )
                                  ],
                                )
                              : const NoProducts(),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
