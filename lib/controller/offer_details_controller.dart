import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OfferDetailsController extends GetxController {
  late List<String> images;
  late PageController pageController;

  var currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // ناخد الصور من Get.arguments
    images = Get.arguments['images'] ?? [];
    pageController = PageController();
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void onSubscribe() {

    Get.snackbar("اشترك", "تم الضغط على زر الاشتراك");
  }

  @override
  void onClose() {
   // pageController.dispose();
    super.onClose();
  }
}
