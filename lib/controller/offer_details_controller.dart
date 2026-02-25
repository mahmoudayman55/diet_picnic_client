import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/custom_snack_bar.dart';

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
    showCustomSnackbar(
        title: "اشترك", message: "تم الضغط على زر الاشتراك", successful: true);
  }

  @override
  void onClose() {
    // pageController.dispose();
    super.onClose();
  }
}
