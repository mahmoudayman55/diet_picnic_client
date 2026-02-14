import 'dart:developer';

import 'package:diet_picnic_client/components/custom_url_luncher.dart';
import 'package:diet_picnic_client/controller/user_controller.dart';
import 'package:diet_picnic_client/models/client_profile_model.dart';
import 'package:diet_picnic_client/models/diet_system_model.dart';
import 'package:get/get.dart';

class DietController extends GetxController {
  late DietSystemModel dietSystem;
  bool showAppBar= false;

  @override
  void onInit() {
    log("message");
    super.onInit();
    log( Get.arguments.toString());

if(Get.arguments!=null) {
  showAppBar=Get.arguments;
  log( showAppBar.toString());
}

    dietSystem = UserController.to.currentUser.value!.dietSystemModel!;
  }

  void openUrl() {
    log(UserController.to.currentUser.value!.assignedDietSystems.toString(),name: "TETSTTT");
    UserController.to.currentUser.value!.assignedDietSystems.forEach((e){
      log(e.id+"----"+dietSystem.id)   ;
    });
    log(UserController.to.currentUser.value!.assignedDietSystems.firstWhere((e)=>e.id==dietSystem.id&&e.isActive).url);
    log(UserController.to.currentUser.value!.assignedDietSystems.firstWhere((e)=>e.id==dietSystem.id&&e.isActive).category);

    final url = UserController.to.currentUser.value!.assignedDietSystems.firstWhere((e)=>e.id==dietSystem.id&&e.isActive).url;
    CustomUrlLauncher.launchGoogleDriveFolder(url);


  }
}
