import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_picnic_client/controller/user_controller.dart';
import 'package:diet_picnic_client/models/week_progress_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddWeekProgressController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final weightController = TextEditingController();
  final pelvisController = TextEditingController();
  final rightArmController = TextEditingController();
  final waistController = TextEditingController();
  final notesController = TextEditingController();
  final excuseController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var selectedDate = Rxn<DateTime>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;

  WeekProgressModel? initialModel;

  // Set date externally
  void setDate(DateTime? date) => selectedDate.value = date;

  // Get argument from Get.arguments
  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments is WeekProgressModel) {
      initialModel = Get.arguments as WeekProgressModel;
      _fillFormFromInitialModel();
    }
  }

  void _fillFormFromInitialModel() {
    if (initialModel == null) return;

    weightController.text = initialModel!.weight != 0 ? initialModel!.weight.toString() : '';
    pelvisController.text = initialModel!.pelvis != 0 ? initialModel!.pelvis.toString() : '';
    rightArmController.text = initialModel!.rightArm != 0 ? initialModel!.rightArm.toString() : '';
    waistController.text = initialModel!.waist != 0 ? initialModel!.waist.toString() : '';
    notesController.text = initialModel!.notes!;
    excuseController.text = initialModel!.excuse;
    selectedDate.value = initialModel!.date;
  }

  String? validateNumber(String? value, String fieldName) {
    // ✅ Skip validation completely if excuse is provided
    if (excuseController.text.trim().isNotEmpty) {
      return null;
    }

    if (value == null || value.trim().isEmpty) {
      return '$fieldName مطلوب';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return '$fieldName يجب أن يكون رقمًا';
    }

    return null;
  }


  Future<void> saveProgress() async {
    final hasExcuse = excuseController.text.trim().isNotEmpty;

    if (!hasExcuse &&
        (!formKey.currentState!.validate() || selectedDate.value == null)) {
      errorMessage.value = 'يرجى تعبئة جميع الحقول بشكل صحيح أو كتابة العذر';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    successMessage.value = '';

    try {
      final clientId = UserController.to.currentUser.value!.id;

      final progress = WeekProgressModel(
        id: initialModel?.id ?? '',
        clientId: clientId,
        weight: hasExcuse || weightController.text.isEmpty
            ? 0.0
            : double.parse(weightController.text),
        pelvis: hasExcuse || pelvisController.text.isEmpty
            ? 0.0
            : double.parse(pelvisController.text),
        rightArm: hasExcuse || rightArmController.text.isEmpty
            ? 0.0
            : double.parse(rightArmController.text),
        waist: hasExcuse || waistController.text.isEmpty
            ? 0.0
            : double.parse(waistController.text),
        notes: notesController.text,
        excuse: excuseController.text,
        date: selectedDate.value ?? DateTime.now(), sentAt: DateTime.now(),
      );

      if (initialModel == null) {
        await _addWeekProgress(progress);
        successMessage.value = 'تمت إضافة التقدم الأسبوعي بنجاح';
      } else {
        await _updateWeekProgress(progress);
        successMessage.value = 'تم تحديث التقدم الأسبوعي بنجاح';
      }
UserController.to.update();
      Get.back();
    } catch (e, stack) {
      log('Error saving progress', error: e, stackTrace: stack);
      errorMessage.value = 'حدث خطأ أثناء الحفظ';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _addWeekProgress(WeekProgressModel weekProgress) async {
    final docRef = firestore
        .collection('clients')
        .doc(weekProgress.clientId)
        .collection('week_progress')
        .doc();

    final newProgress = weekProgress.copyWith(id: docRef.id);

    await docRef.set(newProgress.toJson());

    // Add to user's local list
    UserController.to.currentUser.value!.weekProgressList.add(newProgress);
  }

  Future<void> _updateWeekProgress(WeekProgressModel weekProgress) async {
    final docRef = firestore
        .collection('clients')
        .doc(weekProgress.clientId)
        .collection('week_progress')
        .doc(weekProgress.id);

    await docRef.set(weekProgress.toJson());

    // Replace in user's local list
    final list = UserController.to.currentUser.value!.weekProgressList;
    final index = list.indexWhere((e) => e.id == weekProgress.id);
    if (index != -1) {
      list[index] = weekProgress;
    }
  }
}
