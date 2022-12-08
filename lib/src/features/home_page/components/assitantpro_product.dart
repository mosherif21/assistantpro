import 'package:assistantpro/src/constants/assets_strings.dart';
import 'package:assistantpro/src/features/home_page/components/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../firebase/firebase_manage_data.dart';

class Product extends StatelessWidget {
  const Product({
    Key? key,
    //required this.product,
    required this.screenHeight,
    required this.screenWidth,
    required this.product,
  }) : super(key: key);
  final AssistantProProduct product;
  final double screenHeight;
  final double screenWidth;
  @override
  Widget build(BuildContext context) {
    int count = 1;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: screenHeight * 0.01),
      padding: EdgeInsets.all(screenWidth * 0.02),
      decoration: BoxDecoration(
        color: count > 0 ? Colors.grey.shade300 : Colors.red.shade200,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.getProductName().trim(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Bruno Ace',
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image(
                    image: const AssetImage(kRefrigeratorTray),
                    height: screenWidth * 0.15,
                  ),
                  const SizedBox(width: 5.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.getUsageName().trim(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Bruno Ace',
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.005),
                      Text(
                        'countIs'.tr,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontFamily: 'Bruno Ace',
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
          SizedBox(width: screenWidth * 0.15),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: IconButton(
                  icon: Icon(
                    Icons.settings,
                    size: screenWidth * 0.09,
                  ),
                  color: Colors.black,
                  onPressed: () {},
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              IconButton(
                icon: Icon(
                  Icons.close,
                  size: screenWidth * 0.09,
                ),
                color: Colors.black,
                onPressed: () => FireBaseDataAccess.instance
                    .removeProduct(product.getProductId()),
              ),
              SizedBox(height: screenHeight * 0.005),
            ],
          )
        ],
      ),
    );
  }
}
