import 'dart:async';

import 'package:assistantpro/mqtt/mqtt_product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../src/features/home_page/components/product_model.dart';

class FireBaseDataAccess extends GetxController {
  static FireBaseDataAccess get instance => Get.find();
  var userProducts = <AssistantProProduct>[].obs;
  final _userUid = FirebaseAuth.instance.currentUser?.uid;
  late final DatabaseReference dbRef;
  late final StreamSubscription productsListener;

  @override
  void onClose() {
    productsListener.cancel();
  }

  @override
  void onInit() {
    super.onInit();
    if (_userUid != null) dbRef = FirebaseDatabase.instance.ref();
    if (_userUid != null) listenForUserProducts();
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
                  minimumQuantity:
                      int.parse(productMap['minQuantity'].toString()),
                  currentQuantity:
                      int.tryParse(productMap['currentQuantity'].toString()) ??
                          0,
                  mqttProductHandler: MQTTProductHandler(),
                );
                productsList.add(product);
              }
            }
            userProducts.value = productsList;
          } else {
            userProducts.value = [];
            if (kDebugMode) {
              print('no of user registered products: ${userProducts.length}');
            }
          }
        },
      );
    }
  }

  Future<String> registerNewProduct(String productId, String productName,
      String usageName, int minimumQuantity, int currentQuantity) async {
    var productExist = '';
    if (_userUid != null) {
      removeProduct(productId, productName);
      await dbRef
          .child('products/$productName/$productId')
          .once()
          .then((value) async {
        if (value.snapshot.exists) {
          await dbRef
              .child('products/$productName/$productId/usage')
              .set(usageName);
          await dbRef
              .child('products/$productName/$productId/minQuantity')
              .set(minimumQuantity.toString());
          await dbRef
              .child('products/$productName/$productId/currentQuantity')
              .set(currentQuantity.toString());
          await dbRef
              .child('users/$_userUid/registeredDevices/$productId')
              .set(productName);
          productExist = 'success';
        } else {
          productExist = 'Product doesn\'t exist';
        }
      });
    }
    return productExist;
  }

  Future<bool> checkProductExist(String productId, String productName) async {
    var productExist = false;
    if (_userUid != null) {
      removeProduct(productId, productName);
      await dbRef
          .child('products/$productName/$productId')
          .once()
          .then((value) async {
        if (value.snapshot.exists) productExist = true;
      });
    }
    return productExist;
  }

  Future<void> setNotificationToken(
      String productId, String productName) async {
    if (_userUid != null) {
      final token = await FirebaseMessaging.instance.getToken();
      await dbRef
          .child(
              'products/$productName/$productId/notificationTokens/$_userUid}')
          .set(token);
    }
  }

  Future<void> removeProduct(String productId, String productName) async {
    if (_userUid != null) {
      await dbRef
          .child('users/$_userUid/registeredDevices/$productId')
          .set(null);
      await dbRef
          .child(
              'products/$productName/$productId/notificationTokens/$_userUid}')
          .set(null);
    }
  }
}
