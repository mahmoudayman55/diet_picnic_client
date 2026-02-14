import 'dart:developer';
import 'dart:ui';

import 'dart:ui';

import 'package:diet_picnic_client/controller/user_controller.dart';
import 'package:diet_picnic_client/core/is_valid_phone.dart';
import 'package:diet_picnic_client/core/notification_service.dart';
import 'package:diet_picnic_client/core/notification_test_helper.dart';
import 'package:diet_picnic_client/core/user_storage.dart';
import 'package:diet_picnic_client/firebase_options.dart';
import 'package:diet_picnic_client/view/login_view.dart';
import 'package:diet_picnic_client/view/navigator_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/app_constants.dart';
import 'core/get_routes.dart';
import 'core/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sizer/sizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';

import 'package:crypto/crypto.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (Platform.isWindows) {
  //   WindowManager.instance.setMinimumSize(const Size(800, 800));
  //   WindowManager.instance.setMaximumSize(const Size(800, 800));
  // }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await UserStorage.init();
  
  // Initialize notification service
  await NotificationService.initialize();
  // String hashPassword(String password) {
  //   final bytes = utf8.encode(password); // convert to bytes
  //   final digest = sha256.convert(bytes);
  //   return digest.toString(); // return hex string
  // }
 //updateSubOffersOrderBasedOnLevel();
  // Register UserController globally
  Get.put(UserController());
  // Restore user if already logged in
  await UserController.to.restoreUser();
  await initializeDateFormatting('ar', null); // or your locale

  initializeDateFormatting("ar_SA");
  await Hive.initFlutter();
  await Future.delayed(const Duration(milliseconds: 300));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = UserController.to;

    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          scrollBehavior: MyCustomScrollBehavior(),
          debugShowCheckedModeBanner: false,
          textDirection: TextDirection.rtl,
          locale: const Locale('ar', 'AE'),
          theme: Themes.lightTheme,
          initialRoute:  AppConstants.updatePage,

          getPages: GetRoutes.pages,
        );
      },
    );
  }
}
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods like buildOverscrollIndicator and buildScrollbar
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}