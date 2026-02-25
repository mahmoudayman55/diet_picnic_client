import 'dart:developer';

import 'package:diet_picnic_client/components/custom_snack_bar.dart';
import 'package:diet_picnic_client/controller/diet_controller.dart';
import 'package:diet_picnic_client/controller/exercise_system_controller.dart';
import 'package:diet_picnic_client/controller/user_controller.dart';
import 'package:diet_picnic_client/view/diet_view.dart';
import 'package:diet_picnic_client/view/exercise_system_view.dart';
import 'package:diet_picnic_client/view/home_view.dart';
import 'package:diet_picnic_client/view/login_view.dart';
import 'package:diet_picnic_client/view/progress_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NavigatorController extends GetxController {
  static NavigatorController get to => Get.find();
  String selectedScreenTitle = "الرئيسية";

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  Widget currentScreen = HomeView();

  int currentIndex = 0;
  int lastIndex = 0;
  final userController = UserController.to;

  onNavigate(int index) async {
    lastIndex = currentIndex;
    if (currentIndex != index) {
      Get.delete<DietController>();
      Get.delete<ExerciseSystemController>();
      switch (index) {
        case 0:
          {
            selectedScreenTitle = "الرئيسية";
            currentScreen = HomeView();
            currentIndex = index;

            break;
          }
        case 1:
          {
            if (!userController.isLoggedIn) {
              showCustomSnackbar(
                title: "تنبيه",
                message: "من فضلك سجل الدخول أولاً",
                successful: false,
              );
              return;
            }

            // if (userController.isSubscribed&&userController.currentUser.value!.isExpired) {
            //   showCustomSnackbar(
            //     title: "تنبيه",
            //     message: "يرجى تجديد الإشتراك",
            //     successful: false,
            //   );
            //   return;
            // }

            if (!userController.isSubscriptionActive) {
              showCustomSnackbar(
                title: "تنبيه",
                message: "اشتراكك منتهي، جدد الاشتراك للاستمرار",
                successful: false,
              );
              return;
            }
            // if(!UserController.to.currentUser.value!.hasActiveDiet()){
            //   showCustomSnackbar(
            //     title: "تنبيه",
            //     message: "لم يتم تعيين نظام غذائى.",
            //     successful: false,
            //   );
            //   return;
            // }
            await Get.put(DietController());
            selectedScreenTitle = "النظام الغذائى";
            currentScreen = DietView();
            currentIndex = index;
            break;
          }

        case 2:
          {
            if (!userController.isLoggedIn) {
              showCustomSnackbar(
                title: "تنبيه",
                message: "من فضلك سجل الدخول أولاً",
                successful: false,
              );
              return;
            }

            // if (!userController.isSubscribed) {
            //   showCustomSnackbar(
            //     title: "تنبيه",
            //     message: "انت غير مشترك في أي باقة",
            //     successful: false,
            //   );
            //   return;
            // }

            if (!userController.isSubscriptionActive) {
              showCustomSnackbar(
                title: "تنبيه",
                message: "اشتراكك منتهي، جدد الاشتراك للاستمرار",
                successful: false,
              );
              return;
            }
            // if(!UserController.to.currentUser.value!.hasActiveExercise()){
            //  // log(UserController.to.currentUser.value!.assignedExerciseSystems.join("-"));
            //   showCustomSnackbar(
            //     title: "تنبيه",
            //     message: "لم يتم تعيين نظام رياضى حتى الأن.",
            //     successful: false,
            //   );
            //   return;
            // }
            await Get.put(ExerciseSystemController());
            selectedScreenTitle = "النظام الرياضي";
            currentScreen = ExerciseSystemView();
            currentIndex = index;
            break;
          }

        case 3:
          {
            if (!userController.isLoggedIn) {
              showCustomSnackbar(
                title: "تنبيه",
                message: "من فضلك سجل الدخول أولاً",
                successful: false,
              );
              return;
            }

            if (!userController.isSubscribed) {
              showCustomSnackbar(
                title: "تنبيه",
                message: "انت غير مشترك في أي باقة",
                successful: false,
              );
              return;
            }

            // if (!userController.isSubscriptionActive) {
            //   showCustomSnackbar(
            //     title: "تنبيه",
            //     message: "اشتراكك منتهي، جدد الاشتراك للاستمرار",
            //     successful: false,
            //   );
            //   return;
            // }

            selectedScreenTitle = "التقدم الأسبوعى";
            currentScreen = ProgressView(showAppBar: false);
            currentIndex = index;
            break;
          }
      }
      update();
    }
  }
}
