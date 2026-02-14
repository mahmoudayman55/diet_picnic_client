import 'package:diet_picnic_client/components/custom_url_luncher.dart';
import 'package:diet_picnic_client/controller/user_controller.dart';
import 'package:diet_picnic_client/models/exercise_model.dart';
import 'package:get/get.dart';
import '../models/exercise_system_model.dart';

class ExerciseSystemController extends GetxController {
  late ExerciseSystemModel exerciseSystem;
bool showAppBar= false;
  @override
  void onInit() {
    super.onInit();
    if(Get.arguments!=null) {
      showAppBar=Get.arguments;
    }
    // Dummy Data للتجربة
    exerciseSystem = UserController.to.currentUser.value!.exerciseSystemModel!;
  }

  void openExercise(String url) {
CustomUrlLauncher.launchGoogleDriveFolder(url);
    // هنا تضيف url_launcher
  }
}
