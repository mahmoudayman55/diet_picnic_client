import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_picnic_client/components/custom_snack_bar.dart';
import 'package:diet_picnic_client/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePersonalInfoController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final qualificationController = TextEditingController();
  final addressController = TextEditingController();
  final heightController = TextEditingController();
  final phoneController = TextEditingController();

  final RxString selectedGender = ''.obs;
  final Rx<DateTime?> selectedBirthday = Rx<DateTime?>(null);

  final RxBool isLoading = false.obs;
  final firestore = FirebaseFirestore.instance;

  void onSelectGender(String? value) {
    if (value != null) {
      selectedGender.value = value;
    }
  }
final formKey = GlobalKey<FormState>();
  var socialStatuses = <String>["اعزب", "متزوج", "أرمل","منفصل"].obs;
  var selectedSocialStatus = RxnString();
  void setSocialStatus(String? value) => selectedSocialStatus.value = value;

  Future<void> pickBirthday(BuildContext context) async {

    final now = DateTime.now();
    final initialDate = selectedBirthday.value ?? DateTime(now.year - 18);
    final firstDate = DateTime(1950);
    final lastDate = DateTime(now.year - 5);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      selectedBirthday.value = pickedDate;
    }
  }

  @override
  void onInit() {
    final user = UserController.to.currentUser.value!;
    log(user.height.toString());
    nameController.text = user.name;
    emailController.text = user.email ?? '';
    phoneController.text = user.phone;
    qualificationController.text = user.qualification ?? '';
    selectedSocialStatus.value = user.socialStatus ?? '';
    heightController.text = user.height ?? '';
    selectedGender.value = user.gender ?? '';
    selectedBirthday.value = user.birthDate; // ✅ assuming you have birthDate in model
    super.onInit();
  }

  Future<void> updatePersonalInfo() async {
    if(!formKey.currentState!.validate()){
      return;
    }
    final user = UserController.to.currentUser.value!;
    log(user.package==null?"package is null":user.package!.name,name: "package checking");

    isLoading.value = true;

    try {
      final updatedData = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'qualification': qualificationController.text.trim(),
        'social_status': selectedSocialStatus.trim(),
        'height': heightController.text.trim(),
        'gender': selectedGender.value.trim(),
        'phone': phoneController.text.trim(),
        'birth_date': selectedBirthday.value?.toIso8601String(), // ✅ added
        'address': addressController.text.trim(), // ✅ added
      };

      await firestore.collection('clients').doc(user.id).update(updatedData);

      // Update locally
      final updatedUser = user.copyWith(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        qualification: qualificationController.text.trim(),
        socialStatus:selectedSocialStatus.value==null?null: selectedSocialStatus.value!.trim(),
        height: heightController.text.trim(),
        gender: selectedGender.value.trim(),
        birthDate: selectedBirthday.value,phone: phoneController.text.trim(),
      );
log(user.package==null?"package is null":user.package!.name,name: "package checking");
      await UserController.to.setUser(updatedUser);
      Get.back();
      showCustomSnackbar(
        title: "تم التحديث",
        message: "تم تحديث بياناتك الشخصية بنجاح ✅",
        successful: true,
      );
    } catch (e) {
      showCustomSnackbar(
        title: "خطأ",
        message: "حدث خطأ أثناء تحديث البيانات: $e",
        successful: false,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
