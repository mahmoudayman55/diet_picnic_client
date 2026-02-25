import 'package:diet_picnic_client/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

SnackbarController? showCustomSnackbar({
  required String title,
  required String message,
  required bool successful,
}) {
  return (!Get.isSnackbarOpen)
      ? Get.snackbar(
          title,
          message,
          titleText: Text(
            title,
            style: Themes.lightTheme.textTheme.displayLarge!
                .copyWith(color: Colors.white),
          ),
          messageText: Text(
            message,
            style: Themes.lightTheme.textTheme.displaySmall!
                .copyWith(color: Colors.white),
          ),
          backgroundColor: successful ? Colors.lightGreen : Colors.red,
          icon: Icon(
            successful ? Icons.check : Icons.error,
            color: Colors.white,
          ),
          duration: const Duration(seconds: 3),
        )
      : null;
}
