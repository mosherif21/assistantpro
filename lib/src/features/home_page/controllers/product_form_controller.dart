import 'package:assistantpro/firebase/firebase_manage_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProductAddController extends GetxController {
  static ProductAddController get instance => Get.find();
  final productIdController = TextEditingController();
  final productNameController = TextEditingController();
  final minimumQuantityController = TextEditingController();
  final currentQuantityController = TextEditingController();
  final usageLabelController = TextEditingController();
  RxString returnMessage = ''.obs;
  Future<bool> registerNewProduct(
      String productId, String productName, String usageLabel) async {
    bool success = false;
    if (productId.isEmpty || productName.isEmpty || usageLabel.isEmpty) {
      returnMessage.value = 'Fields can\'t be empty';
    } else {
      returnMessage.value = await FireBaseDataAccess.instance
          .registerNewProduct(productId, productName, usageLabel);
      success = true;
    }
    return success;
  }
}
