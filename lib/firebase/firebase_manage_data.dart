import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../src/features/home_page/components/product_model.dart';

class FireBaseDataAccess extends GetxController {
  static FireBaseDataAccess get instance => Get.find();
  var userProducts = <AssistantProProduct>[].obs;
  DatabaseReference dbRef = FirebaseDatabase.instance.ref();
  final _userUid = FirebaseAuth.instance.currentUser?.uid;

  //
  // Future<void> getIfUserHasRegisteredProducts() async {
  //   await dbRef.child('users/$_userUid/registeredDevices').once().then(
  //     (existEvent) async {
  //       final snapshot = existEvent.snapshot;
  //       if (snapshot.exists) {
  //         final productsList = <AssistantProProduct>[];
  //         for (var product in snapshot.children) {
  //           final productId = product.key;
  //           final productName = product.value;
  //           final snapshot =
  //               await dbRef.child('products/$productName/$productId').get();
  //           if (snapshot.exists) {
  //             Map<String, dynamic> productMap =
  //                 snapshot.value as Map<String, dynamic>;
  //             final product = AssistantProProduct(
  //               productName: productName.toString(),
  //               macAddress: productMap['macAddress'],
  //               getTopic: productMap['getTopic'],
  //               setTopic: productMap['setTopic'],
  //               usageName: productMap['usage'],
  //               productId: productId.toString(),
  //             );
  //             if (kDebugMode) print(product.toString());
  //             productsList.add(product);
  //           }
  //         }
  //         userProducts.value = productsList;
  //       }
  //     },
  //     onError: (e) {
  //       if (kDebugMode) e.printError();
  //     },
  //   );
  // }

  @override
  void onReady() {
    listenForUserProducts();
  }

  void listenForUserProducts() {
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
              Map<String, dynamic> productMap =
                  snapshot.value as Map<String, dynamic>;
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

  Future<bool> registerNewProduct(
      String productId, String productName, String usageName) async {
    var productExist = false;
    await dbRef
        .child('products/$productName/$productId')
        .once()
        .then((value) async {
      if (value.snapshot.exists) {
        await dbRef
            .child('users/$_userUid/registeredDevices/$productId')
            .set(productName);
        await dbRef
            .child('products/$productName/$productId/usage')
            .set(usageName);
        productExist = true;
      }
    });
    return productExist;
  }

  Future<void> removeProduct(String productId) async {
    await dbRef.child('users/$_userUid/registeredDevices/$productId').set(null);
  }
}
