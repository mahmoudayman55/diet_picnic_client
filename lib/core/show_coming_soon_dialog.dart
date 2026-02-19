import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showComingSoonDialog() {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Text(
              "قريبًا 🔥",
              style: Get.textTheme.headlineLarge?.copyWith(

                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "الميزة دي تحت التطوير حالياً، وهنعلن عنها قريب جدًا!\nخليك متابع علشان تشوف الجديد 🎯",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.selectedNavBarColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              onPressed: () => Get.back(),
              child: const Text(
                "حسنًا 👌",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: true,
  );
}
