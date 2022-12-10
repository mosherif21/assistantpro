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
  Future<bool> registerNewProduct() async {
    String productId = productIdController.text.trim();
    String productName = productNameController.text.trim();
    String usageLabel = usageLabelController.text.trim();

    bool minQIsInt = int.tryParse(minimumQuantityController.text.trim()) != null
        ? true
        : false;
    bool currentQIsInt =
        int.tryParse(currentQuantityController.text.trim()) != null
            ? true
            : false;
    bool success = false;
    if (productId.isEmpty || productName.isEmpty || usageLabel.isEmpty) {
      returnMessage.value = 'Fields can\'t be empty';
    } else if (minQIsInt && currentQIsInt) {
      if (int.parse(minimumQuantityController.text.trim()) >= 0 &&
          int.parse(currentQuantityController.text.trim()) > 0) {
        returnMessage.value = await FireBaseDataAccess.instance
            .registerNewProduct(
                productId,
                productName,
                usageLabel,
                int.parse(minimumQuantityController.text.trim()),
                int.parse(currentQuantityController.text.trim()));
        success = true;
      } else {
        returnMessage.value =
            'Current quantity and Min quantity must be non negative integers';
      }
    } else {
      returnMessage.value =
          'Current quantity and Min quantity must be non negative integers';
    }
    return success;
  }
}
