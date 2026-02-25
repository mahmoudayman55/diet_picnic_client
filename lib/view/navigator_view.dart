import 'dart:developer';

import 'package:diet_picnic_client/components/custom_app_bar.dart';
import 'package:diet_picnic_client/controller/navigator_controller.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NavigatorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigatorController>(
        init: NavigatorController(),
        builder: (controller) {
          return Scaffold(
            appBar: CustomAppBar(title: controller.selectedScreenTitle),
            extendBodyBehindAppBar: false,
            resizeToAvoidBottomInset: false,
            body: controller.currentScreen,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: controller.currentIndex,
              onTap: (value) => controller.onNavigate(value),
              type: BottomNavigationBarType.fixed,
              // Now pulls directly from Theme
              backgroundColor:
                  Theme.of(context).bottomNavigationBarTheme.backgroundColor,
              selectedItemColor:
                  Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
              unselectedItemColor: Theme.of(context)
                  .bottomNavigationBarTheme
                  .unselectedItemColor,
              showUnselectedLabels: true,
              elevation: 0,
              selectedLabelStyle: TextStyle(
                fontFamily: AppConstants.fontFamily,
                fontWeight: FontWeight.w600,
                fontSize: 8,
                color: Theme.of(context)
                    .bottomNavigationBarTheme
                    .selectedItemColor,
              ),
              unselectedLabelStyle: TextStyle(
                fontFamily: AppConstants.fontFamily,
                fontWeight: FontWeight.w400,
                fontSize: 8,
                color: Theme.of(context)
                    .bottomNavigationBarTheme
                    .unselectedItemColor,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(CupertinoIcons.home),
                  // activeIcon: const Icon(Icons.home),
                  label: "الرئيسية".tr,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.fastfood_outlined),
                  //   activeIcon: const Icon(Icons.book_online),
                  label: "النظام الغذائى".tr,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.sports_outlined),
                  //   activeIcon: const Icon(Icons.book_online),
                  label: "النظام الرياضى".tr,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.trending_up),
                  //   activeIcon: const Icon(Icons.book_online),
                  label: "التقدم".tr,
                ),
              ],
            ),
          );
        });
  }
}
