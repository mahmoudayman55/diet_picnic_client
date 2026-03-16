import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

void showCustomSnackbar({
 required String title,
 required String message,
 required bool successful,
}) {
  final messenger = AppConstants.snackbarKey.currentState;
  if (messenger == null) return;

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        showCloseIcon: true,
        duration:
            Duration(minutes: successful ? 0 : 3, seconds: successful ? 3 : 0),
        backgroundColor: successful ? Colors.lightGreen : Colors.red,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,fontSize: 16
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: const TextStyle(color: Colors.white,fontSize: 12),
            ),
          ],
        ),
      ),
    );
}

// SnackbarController? showCustomSnackbar({
//   required String title,
//   required String message,
//   required bool successful,
// }) {
//   return (!Get.isSnackbarOpen)
//       ? Get.snackbar(
//           title,
//           message,
//           titleText: Text(
//             title,
//             style: Themes.lightTheme.textTheme.displayLarge!
//                 .copyWith(color: Colors.white),
//           ),
//           messageText: Text(
//             message,
//             style: Themes.lightTheme.textTheme.displaySmall!
//                 .copyWith(color: Colors.white),
//           ),
//           backgroundColor: successful ? Colors.lightGreen : Colors.red,
//           icon: Icon(
//             successful ? Icons.check : Icons.error,
//             color: Colors.white,
//           ),
//           duration: const Duration(seconds: 3),
//         )
//       : null;
// }
