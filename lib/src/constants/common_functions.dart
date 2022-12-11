import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../firebase/firebase_manage_data.dart';
import '../features/home_page/screens/home_page_screen.dart';

double getScreenHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getScreenWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

void getToHomePage() {
  Get.put(FireBaseDataAccess());
  Get.offAll(() => const HomePageScreen());
}
