import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../src/features/home_page/components/product_model.dart';

class FireBaseDataAccess extends GetxController {
  static FireBaseDataAccess get instance => Get.find();
  var userProducts = <AssistantProProduct>[].obs;
  final _userUid = FirebaseAuth.instance.currentUser?.uid;
  late final DatabaseReference dbRef;
  late final StreamSubscription productsListener;
  FireBaseDataAccess() {
    if (_userUid != null) dbRef = FirebaseDatabase.instance.ref();
  }
  @override
  void onInit() async {
    super.onInit();
    if (_userUid != null) listenForUserProducts();
  }

  @override
  void onClose() async {
    await productsListener.cancel();
  }

  void listenForUserProducts() {
    if (_userUid != null) {
      productsListener =
          dbRef.child('users/$_userUid/registeredDevices').onValue.listen(
        (event) async {
          final snapShot = event.snapshot;
          if (snapShot.exists) {
            final productsList = <AssistantProProduct>[];
            for (var product in snapShot.children) {
              final productId = product.key;
              final productName = product.value;
              final snapshot =
                  await dbRef.child('products/$productName/$productId').get();
              if (snapshot.exists) {
                Map<dynamic, dynamic> productMap =
                    snapshot.value as Map<dynamic, dynamic>;
                final product = AssistantProProduct(
                  productName: productName.toString(),
                  macAddress: productMap['macAddress'],
                  getTopic: productMap['getTopic'],
                  setTopic: productMap['setTopic'],
                  usageName: productMap['usage'],
                  productId: productId.toString(),
                );
                if (kDebugMode) print(product.toString());
                productsList.add(product);
              }
            }
            userProducts.value = productsList;
            if (kDebugMode) print(userProducts.length);
          } else {
            userProducts.value = [];
            if (kDebugMode) print(userProducts.length);
          }
        },
      );
    }
  }

  Future<String> registerNewProduct(
      String productId, String productName, String usageName) async {
    var productExist = '';
    if (_userUid != null) {
      await dbRef
          .child('products/$productName/$productId')
          .once()
          .then((value) async {
        if (value.snapshot.exists) {
          await dbRef
              .child('products/$productName/$productId/usage')
              .set(usageName);
          await dbRef
              .child('users/$_userUid/registeredDevices/$productId')
              .set(productName);
          return 'success';
        } else {
          return 'Product doesn\'t exist';
        }
      });
    }
    return productExist;
  }

  Future<void> removeProduct(String productId) async {
    if (_userUid != null) {
      await dbRef
          .child('users/$_userUid/registeredDevices/$productId')
          .set(null);
    }
  }
}
