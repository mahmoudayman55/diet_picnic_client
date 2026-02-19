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
  void onInit()async {
    super.onInit();

if(Get.arguments!=null) {
  showAppBar=Get.arguments;
}
checkDietSystem();

  }
  Rx<bool> hasDietSystem=Rx(false);
  Rx<bool> loading=Rx(false);

  checkDietSystem()async{
    loading.value =true;
  await UserController.to.refreshDietSystem();
  hasDietSystem.value=UserController.to.currentUser.value!.hasActiveDiet();
    if (hasDietSystem.value) {
      dietSystem = UserController.to.currentUser.value!.dietSystemModel!;
    }
  loading.value=false;
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
