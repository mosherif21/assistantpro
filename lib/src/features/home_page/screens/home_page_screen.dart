import 'package:assistantpro/firebase/firebase_manage_data.dart';
import 'package:assistantpro/src/common_widgets/regular_bottom_sheet.dart';
import 'package:assistantpro/src/common_widgets/regular_elevated_button.dart';
import 'package:assistantpro/src/constants/app_init_constants.dart';
import 'package:assistantpro/src/constants/assets_strings.dart';
import 'package:assistantpro/src/constants/common_functions.dart';
import 'package:assistantpro/src/features/home_page/components/no_products_error.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../../authentication/authentication_repository.dart';
import '../../../connectivity/connectivity.dart';
import '../components/assitantpro_product.dart';
import '../components/select_add_product.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ConnectivityChecker.checkConnection(true);
    double screenHeight = getScreenHeight(context);

    final firebaseDataController = FireBaseDataAccess.instance;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(screenHeight * 0.02),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: const AssetImage(kLogoImage),
                    height: screenHeight * 0.08,
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: screenHeight * 0.027, left: screenHeight * 0.01),
                    child: Text(
                      'AssistantPro',
                      style: TextStyle(
                          fontFamily: 'Bruno Ace',
                          color: Colors.white,
                          fontSize: screenHeight * 0.02),
                    ),
                  ),
                  SizedBox(width: screenHeight * 0.012),
                  Container(
                    margin: EdgeInsets.only(
                        top: screenHeight * 0.027, left: screenHeight * 0.01),
                    child: TextButton(
                      onPressed: () {},
                      child: Text(
                        AppInit.currentDeviceLanguage == Language.english
                            ? 'ENG'
                            : 'AR',
                        style: TextStyle(
                            fontFamily: 'Bruno Ace',
                            fontSize: screenHeight * 0.02,
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
                        height: screenHeight * 0.04,
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
                    height: screenHeight * 0.65,
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
                                        product: product,
                                      )
                                  ],
                                )
                              : const NoProducts(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  // Container(
                  //   width: double.infinity,
                  //   decoration: const BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.only(
                  //       topRight: Radius.circular(15),
                  //       topLeft: Radius.circular(15),
                  //     ),
                  //   ),
                  // ),
                  RegularElevatedButton(
                    buttonText: 'Add device',
                    height: screenHeight,
                    onPressed: () => RegularBottomSheet.showRegularBottomSheet(
                        const ChooseAddDeviceMethod()),
                    enabled: true,
                  ),
                  const SizedBox(height: 10.0),
                  RegularElevatedButton(
                    buttonText: 'Logout',
                    height: screenHeight,
                    onPressed: () =>
                        AuthenticationRepository.instance.logoutUser(),
                    enabled: true,
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
