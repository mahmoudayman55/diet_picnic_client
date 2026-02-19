import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:diet_picnic_client/components/custom_snack_bar.dart';
import 'package:diet_picnic_client/controller/home_controller.dart';
import 'package:diet_picnic_client/controller/user_controller.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/models/client_profile_model.dart';
import 'package:diet_picnic_client/models/diet_system_model.dart';
import 'package:diet_picnic_client/models/exercise_system_model.dart';
import 'package:diet_picnic_client/models/follow_up_message_model.dart';
import 'package:diet_picnic_client/models/package.dart';
import 'package:diet_picnic_client/models/package_model.dart';
import 'package:diet_picnic_client/models/week_progress_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
final formKey = GlobalKey<FormState>();
  var isLoading = false.obs;

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  Future<List<FollowUpMessageModel>> getFollowUpsForClient(
      String clientId) async {
    final snapshot = await firestore
        .collection('clients')
        .doc(clientId)
        .collection('follow_ups')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Add the document ID to the JSON
      return FollowUpMessageModel.fromJson(data);
    }).toList();
  }

  Future<void> login() async {

    if(!formKey.currentState!.validate()){
      log(formKey.currentState!.validate().toString());
      return;
    }
    final phone = phoneController.text.trim();
    final password = passwordController.text;

    if (phone.isEmpty || password.isEmpty) {
      customSnackBar(
        title: "تنبيه",
        message: "من فضلك أدخل رقم الهاتف وكلمة المرور",
        successful: false,
      );
      return;
    }

    isLoading.value = true;

    try {
      // 🔍 Find client by phone
      final snapshot = await firestore
          .collection("clients")
          .where("phone", isEqualTo: phone)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        customSnackBar(
          title: "خطأ",
          message: "رقم الهاتف غير مسجل",
          successful: false,
        );
        return;
      }

      final doc = snapshot.docs.first;
      final data = doc.data();
      final storedHashedPassword = data["password"] ?? "";
      final inputHashedPassword = _hashPassword(password);

      if (storedHashedPassword == inputHashedPassword) {
        final clientId = doc.id;

        // ✅ 1. Fetch all packages
        final packagesSnapshot = await firestore.collection('packages').get();
        final packagesMap = <String, Package>{};
        for (var pkg in packagesSnapshot.docs) {
          final pkgData = pkg.data();
          final pkgId = pkgData['id'] ?? pkg.id;
          final pkgName = pkgData['name'] ?? '';
          packagesMap[pkgId] = Package(id: pkgId, name: pkgName);
        }

        // ✅ 2. Resolve package
        final packageId = data['package_id'] ?? '';
        Package? package;
        if (packagesMap.containsKey(packageId)) {
          package = packagesMap[packageId]!;
        } else {
          package = null;
        }

        // ✅ 3. Resolve group if exists
        PackageGroup? packageGroup;
        final groupId = data['group_id'];
        if (groupId != null && (groupId as String).isNotEmpty) {
          final groupDoc =
              await firestore.collection('groups').doc(groupId).get();
          if (groupDoc.exists) {
            packageGroup = PackageGroup.fromJson(groupDoc.data()!);
          }
        }

        // ✅ 4. Fetch week progress
        final weekProgressSnapshot = await firestore
            .collection('clients')
            .doc(clientId)
            .collection('week_progress')
            .get();
        final weekProgressList = weekProgressSnapshot.docs
            .map((wp) => WeekProgressModel.fromJson(wp.data()))
            .toList();
        ClientProfileModel user = ClientProfileModel.fromJson(data, clientId).copyWith(
          weekProgressList: weekProgressList,
          group: packageGroup,
          package: package,
        );

        // ✅ 5. Fetch followUps
        final followUpList = await getFollowUpsForClient(clientId);
        // Get active diet system
        DietSystemModel? dietSystemModel;
        final assignedDietSystems = user.assignedDietSystems;

        if (assignedDietSystems.isNotEmpty) {
          final activeDietSystem = assignedDietSystems.firstWhereOrNull(
                (system) => system.isActive == true,
          );

          if (activeDietSystem != null) {
            final doc = await firestore
                .collection("diet_systems")
                .doc(activeDietSystem.id)
                .get();

            if (doc.exists && doc.data() != null) {
              dietSystemModel = DietSystemModel.fromJson(doc.data()!,activeDietSystem.assignedAt);
            }
          }
        }

// Get active exercise system
        ExerciseSystemModel? exerciseSystemModel;
        final assignedExerciseSystems = user.assignedExerciseSystems;

        if (assignedExerciseSystems.isNotEmpty) {
          final activeExerciseSystem = assignedExerciseSystems.firstWhereOrNull(
                (system) => system.isActive == true,
          );
        //  log(activeExerciseSystem!.id,name: "ACTIVEONE");

          if (activeExerciseSystem != null) {
            final exerciseDoc = await firestore
                .collection("exercise_systems")
                .doc(activeExerciseSystem.id)
                .get();

            if (exerciseDoc.exists && exerciseDoc.data() != null) {
              exerciseSystemModel = ExerciseSystemModel.fromJson(
                exerciseDoc.data()!,
                exerciseDoc.id,
              );
            }
          }
        }




        user = ClientProfileModel.fromJson(data, clientId).copyWith(
          weekProgressList: weekProgressList,
          dietSystemModel: dietSystemModel,
          exerciseSystemModel: exerciseSystemModel,
          group: packageGroup,
          package: package,
        );
        // ✅ 7. Save in UserController + UserStorage
        await UserController.to.setUser(user);
         // log(UserController.to.currentUser.value!.dietSystemModel!.name);
        customSnackBar(
          title: "نجاح",
          message: "تم تسجيل الدخول بنجاح 🎉",
          successful: true,
        );
        Get.put(HomeController());
        Get.offAllNamed(AppConstants.navigatorPage);

      } else {
        customSnackBar(
          title: "خطأ",
          message: "كلمة المرور غير صحيحة",
          successful: false,
        );
      }
    } catch (e) {

      customSnackBar(
        title: "خطأ",
        message: "فشل تسجيل الدخول: $e",
        successful: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // phoneController.dispose();
    // passwordController.dispose();
    super.onClose();
  }
}
