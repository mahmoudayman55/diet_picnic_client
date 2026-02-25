import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_picnic_client/components/custom_snack_bar.dart';
import 'package:diet_picnic_client/controller/user_controller.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:diet_picnic_client/core/app_constants.dart';

class AppUpdateController extends GetxService {
  static AppUpdateController get to => Get.find();

  @override
  void onInit() {
    checkAppVersion();
    super.onInit();
  }
  final _firestore = FirebaseFirestore.instance;
  final isLoading = false.obs;
  final appVersion = ''.obs;
  final remoteVersion = ''.obs;
  final deadline = Rxn<DateTime>();
  final playStoreUrl = ''.obs;
  final needsUpdate = false.obs;
  final inMaintenance = false.obs;
  final daysRemaining = 0.obs;

  /// Fetch app config from Firebase
  Future<void> checkAppVersion() async {
    try {
      isLoading.value = true;

      // Get current app version
      final info = await PackageInfo.fromPlatform();
      appVersion.value = info.version;

      // Get remote data
      final doc = await _firestore.collection("app").doc("e4bqcpJ89mMFZ8xx5Zhp").get();
      if (!doc.exists) {
        showCustomSnackbar(
          title: "خطأ",
          message: "لم يتم العثور على إعدادات التطبيق في الخادم",
          successful: false,
        );
        return;
      }

      final data = doc.data()!;
      remoteVersion.value = data["version"] ?? "";
      playStoreUrl.value = data["playstore_url"] ?? "";
      if(remoteVersion.value=="0.0.0"){
        inMaintenance.value=true;
        return;
      }
      if (data["deadline"] != null) {
        deadline.value = DateTime.tryParse(data["deadline"]);

      }

      // Compare versions
      if (appVersion.value != remoteVersion.value) {
        needsUpdate.value = true;
        if (deadline.value != null) {
          final now = DateTime.now();
          final remaining = deadline!.value!.difference(now).inDays;
          daysRemaining.value = remaining;
        }
        isLoading.value = false;

        // Navigate to update view
     //   Get.offAllNamed(AppConstants.updatePage);
      } else {
        // Continue normally
        Get.offAllNamed(AppConstants.navigatorPage);
      }

    } catch (e) {
      showCustomSnackbar(
        title: "خطأ",
        message: "فشل التحقق من التحديث: $e",
        successful: false,
      );
      isLoading.value = false;
    }
  }

  void launchPlayStore() async {
    final url = playStoreUrl.value;
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      showCustomSnackbar(
        title: "خطأ",
        message: "تعذر فتح متجر Play",
        successful: false,
      );
    }
  }
}
