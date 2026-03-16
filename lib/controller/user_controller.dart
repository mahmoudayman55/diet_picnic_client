import 'dart:developer';
import 'dart:io';

import 'package:diet_picnic_client/components/custom_snack_bar.dart';
import 'package:diet_picnic_client/controller/navigator_controller.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/core/imgbb_uploader.dart';
import 'package:diet_picnic_client/models/diet_system_model.dart';
import 'package:diet_picnic_client/models/exercise_system_model.dart';
import 'package:diet_picnic_client/models/follow_up_message_model.dart';
import 'package:diet_picnic_client/models/package.dart';
import 'package:diet_picnic_client/models/package_model.dart';
import 'package:diet_picnic_client/models/week_progress_model.dart';
import 'package:get/get.dart';
import 'package:diet_picnic_client/models/client_profile_model.dart';
import 'package:diet_picnic_client/core/user_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();

  final currentUser = Rxn<ClientProfileModel>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// Called after login/register
  Future<void> setUser(ClientProfileModel user) async {
    currentUser.value = user;
    await UserStorage.saveUserId(user.id);
  }

  bool get isLoggedIn => currentUser.value != null;
  bool get isSubscribed => currentUser.value!.package != null;
  bool get isSubscriptionActive => !currentUser.value!.isExpired;

  /// Restore user if saved in storage
  final isRestoringUser = false.obs;

  Future<void> restoreUser() async {
    isRestoringUser.value = true;
    try {
      final userId = UserStorage.getUserId();
      if (userId == null) return;

      final doc = await firestore.collection("clients").doc(userId).get();
      if (doc.exists) {
        log(userId.toString());
        currentUser.value = ClientProfileModel.fromJson(doc.data()!, doc.id);

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
        final packageId = doc.data()!['package_id'] ?? '';
        Package? package;
        if (packagesMap.containsKey(packageId)) {
          package = packagesMap[packageId]!;
        } else {
          package = null;
        }

        // ✅ 3. Resolve group if exists
        PackageGroup? packageGroup;
        final groupId = doc.data()!['group_id'];
        log("GROUP ID IS $groupId");
        if (groupId != null && (groupId as String).isNotEmpty) {
          final groupDoc =
          await firestore.collection('groups').doc(groupId).get();
          if (groupDoc.exists) {
            packageGroup = PackageGroup.fromJson(groupDoc.data()!);
            log("GROUP NAME IS ${packageGroup.name}");
          }
        }

        // ✅ 4. Fetch week progress
        final weekProgressSnapshot = await firestore
            .collection('clients')
            .doc(currentUser.value!.id)
            .collection('week_progress')
            .get();
        final weekProgressList = weekProgressSnapshot.docs
            .map((wp) => WeekProgressModel.fromJson(wp.data()))
            .toList();

        ClientProfileModel user =
        ClientProfileModel.fromJson(doc.data()!, doc.id).copyWith(
          weekProgressList: weekProgressList,
          group: packageGroup,
          package: package,
        );

        Future<List<FollowUpMessageModel>> getFollowUpsForClient(
            String clientId) async {
          final snapshot = await firestore
              .collection('clients')
              .doc(clientId)
              .collection('follow_ups')
              .get();

          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return FollowUpMessageModel.fromJson(data);
          }).toList();
        }

        // ✅ 5. Fetch followUps
        final followUpList = await getFollowUpsForClient(doc.id);
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
              dietSystemModel = DietSystemModel.fromJson(
                  doc.data()!, activeDietSystem.assignedAt);
            }
          }
        }

        // ✅ 6. Get active exercise system
        ExerciseSystemModel? exerciseSystemModel;
        final assignedExerciseSystems = user.assignedExerciseSystems;

        if (assignedExerciseSystems.isNotEmpty) {
          final activeExerciseSystem = assignedExerciseSystems.firstWhereOrNull(
                (system) => system.isActive == true,
          );

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
              log("EXISTEX");
            }
          }
        }
        log("GROUP NAME IS ${packageGroup.toString()}");

        user = ClientProfileModel.fromJson(doc.data()!, doc.id).copyWith(
          weekProgressList: weekProgressList,
          dietSystemModel: dietSystemModel,
          assignedDietSystems: assignedDietSystems,
          assignedExerciseSystems: assignedExerciseSystems,
          exerciseSystemModel: exerciseSystemModel,
          group: packageGroup,packageGroup: packageGroup,
          package: package,
        );
        log("GROUP NAME IS ${user.packageGroup.toString()}");
        currentUser.value = user;
        update();
      }
    } finally {
      isRestoringUser.value = false;
    }
  }
  Future<void> refreshExerciseSystem() async {
    log("message started");
    if (currentUser.value == null) return;

    final userId = currentUser.value!.id;

    // Fetch fresh user data from Firestore
    final userDoc = await firestore.collection("clients").doc(userId).get();

    if (!userDoc.exists) return;

    final userData = userDoc.data()!;

    // ✅ Use the correct field name with underscore
    final assignedExerciseSystems =
        (userData['assigned_exercise_systems'] as List?)
                ?.map((e) => AssignedExerciseSystem.fromJson(e))
                .toList() ??
            [];

    log("Parsed assignedExerciseSystems count: ${assignedExerciseSystems.length}");

    ExerciseSystemModel? exerciseSystemModel;

    if (assignedExerciseSystems.isNotEmpty) {
      final activeExerciseSystem = assignedExerciseSystems.firstWhereOrNull(
        (system) => system.isActive == true,
      );

      if (activeExerciseSystem != null) {
        log("Active exercise system found with ID: ${activeExerciseSystem.id}");

        final exerciseDoc = await firestore
            .collection("exercise_systems")
            .doc(activeExerciseSystem.id)
            .get();

        if (exerciseDoc.exists && exerciseDoc.data() != null) {
          exerciseSystemModel = ExerciseSystemModel.fromJson(
            exerciseDoc.data()!,
            exerciseDoc.id,
          );
          log("Exercise system loaded: ${exerciseSystemModel.name}");
        }
      } else {
        log("No active exercise system found");
      }
    } else {
      log("No assigned exercise systems");
    }

    // Rebuild the entire user object from Firestore
    currentUser.value = ClientProfileModel.fromJson(userData, userId).copyWith(
      weekProgressList: currentUser.value!.weekProgressList,
      dietSystemModel: currentUser.value!.dietSystemModel,
      assignedDietSystems: currentUser.value!.assignedDietSystems,
      assignedExerciseSystems: assignedExerciseSystems,
      exerciseSystemModel: exerciseSystemModel,
      group: currentUser.value!.group,
      package: currentUser.value!.package,
    );

    update();
    log("Final exercise system: ${currentUser.value!.exerciseSystemModel?.name ?? 'null'}");
  }

  Future<void> refreshDietSystem() async {
    if (currentUser.value == null) return;

    final userId = currentUser.value!.id;

    // Fetch fresh user data from Firestore
    final userDoc = await firestore.collection("clients").doc(userId).get();

    if (!userDoc.exists) return;

    final userData = userDoc.data()!;

    // ✅ Use the correct field name with underscore
    final assignedDietSystems = (userData['assigned_diet_systems'] as List?)
            ?.map((e) => AssignedDietSystem.fromJson(e))
            .toList() ??
        [];

    log("Parsed assignedDietSystems count: ${assignedDietSystems.length}");

    DietSystemModel? dietSystemModel;

    if (assignedDietSystems.isNotEmpty) {
      final activeDietSystem = assignedDietSystems.firstWhereOrNull(
        (system) => system.isActive == true,
      );

      if (activeDietSystem != null) {
        log("Active diet system found with ID: ${activeDietSystem.id}");

        final doc = await firestore
            .collection("diet_systems")
            .doc(activeDietSystem.id)
            .get();
        log("DATEIS${doc.data()}");
        if (doc.exists && doc.data() != null) {
          dietSystemModel = DietSystemModel.fromJson(
              doc.data()!, activeDietSystem.assignedAt);
          log("Diet system loaded: ${dietSystemModel.name}");
        }
      } else {
        log("No active diet system found");
      }
    } else {
      log("No assigned diet systems");
    }

    // Rebuild the entire user object from Firestore
    currentUser.value = ClientProfileModel.fromJson(userData, userId).copyWith(
      weekProgressList: currentUser.value!.weekProgressList,
      dietSystemModel: dietSystemModel,
      assignedDietSystems: assignedDietSystems,
      assignedExerciseSystems: currentUser.value!.assignedExerciseSystems,
      exerciseSystemModel: currentUser.value!.exerciseSystemModel,
      group: currentUser.value!.group,
      package: currentUser.value!.package,
    );

    update();
    log("Final diet system: ${currentUser.value!.dietSystemModel?.name ?? 'null'}");
  }

  ///profile pic
  final _firestore = FirebaseFirestore.instance;
  final _picker = ImagePicker();

  /// Pick image and update Firestore + local user
  Future<void> pickAndUploadProfileImage() async {
    try {
      // Pick image from gallery
      final pickedFile = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 50);
      if (pickedFile == null || pickedFile.path.isEmpty) {
        showCustomSnackbar(
          title: "لم يتم اختيار صورة",
          message: "من فضلك اختر صورة صالحة من جهازك",
          successful: false,
        );
        return;
      }

      final file = File(pickedFile.path);
      if (!await file.exists()) {
        showCustomSnackbar(
          title: "خطأ",
          message: "تعذر الوصول إلى الملف المحدد",
          successful: false,
        );
        return;
      }

      final userController = UserController.to;
      final userId = userController.currentUser.value?.id;
      if (userId == null || userId.isEmpty) {
        showCustomSnackbar(
          title: "خطأ",
          message: "لم يتم العثور على بيانات المستخدم",
          successful: false,
        );
        return;
      }

      // Upload image to imgbb
      showCustomSnackbar(
        title: "جاري التحميل",
        message: "يتم الآن رفع الصورة...",
        successful: true,
      );

      final imageUrl = await ImgbbUploader.uploadImage(file);
      if (imageUrl == null) {
        showCustomSnackbar(
          title: "خطأ",
          message: "فشل رفع الصورة إلى الخادم",
          successful: false,
        );
        return;
      }

      // Update Firestore
      await _firestore.collection("clients").doc(userId).update({
        "image": imageUrl,
      });

      // Update local user in controller
      userController.currentUser.value =
          userController.currentUser.value!.copyWith(image: imageUrl);
      userController.currentUser.refresh();

      showCustomSnackbar(
        title: "تم بنجاح 🎉",
        message: "تم تحديث الصورة الشخصية بنجاح",
        successful: true,
      );
    } catch (e) {
      showCustomSnackbar(
        title: "خطأ",
        message: "حدث خطأ أثناء تحديث الصورة: $e",
        successful: false,
      );
    }
  }

  /// Logout
  Future<void> logout() async {
    currentUser.value = null;
    await UserStorage.clearUser();
    UserController.to.update();
    Get.find<NavigatorController>().update();

    Get.offAllNamed(AppConstants.loginPage);
  }
}
