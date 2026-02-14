import 'package:diet_picnic_client/components/custom_snack_bar.dart';
import 'package:diet_picnic_client/models/body_composition_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class BodyCompositionController extends GetxController {
  static BodyCompositionController get to => Get.find();

  final GetStorage _storage = GetStorage();
  static const String _storageKey = 'body_composition_data';

  // Observable variables
  final isLoading = false.obs;
  final showResults = false.obs;
  final isCalculating = false.obs;

  // Input fields
  final selectedGender = 'ذكر'.obs;
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final waistController = TextEditingController();
  final hipController = TextEditingController();

  // Results
  final bodyCompositionResult = Rxn<BodyCompositionModel>();

  // Gender options
  final List<String> genderOptions = ['ذكر', 'أنثى'];

  @override
  void onInit() {
    super.onInit();
    _loadSavedData();
  }

  @override
  void onClose() {
    heightController.dispose();
    weightController.dispose();
    waistController.dispose();
    hipController.dispose();
    super.onClose();
  }

  /// Load saved data from storage
  void _loadSavedData() {
    try {
      final savedData = _storage.read(_storageKey);
      if (savedData != null) {
        final model = BodyCompositionModel.fromJson(savedData);
        selectedGender.value = model.gender;
        heightController.text = model.height.toString();
        weightController.text = model.weight.toString();
        waistController.text = model.waistCircumference.toString();
        hipController.text = model.hipCircumference.toString();
      }
    } catch (e) {
      if (Get.isLogEnable) {
        print('Error loading saved data: $e');
      }
    }
  }

  /// Save data to storage
  void _saveData() {
    try {
      final model = BodyCompositionModel(
        gender: selectedGender.value,
        height: double.tryParse(heightController.text) ?? 0,
        weight: double.tryParse(weightController.text) ?? 0,
        waistCircumference: double.tryParse(waistController.text) ?? 0,
        hipCircumference: double.tryParse(hipController.text) ?? 0,
      );
      _storage.write(_storageKey, model.toJson());
    } catch (e) {
      if (Get.isLogEnable) {
        print('Error saving data: $e');
      }
    }
  }

  /// Change gender selection
  void changeGender(String gender) {
    selectedGender.value = gender;
  }

  /// Validate input fields
  bool _validateInputs() {
    final height = double.tryParse(heightController.text);
    final weight = double.tryParse(weightController.text);
    final waist = double.tryParse(waistController.text);
    final hip = double.tryParse(hipController.text);

    if (height == null || height <= 0) {
      customSnackBar(
        title: 'خطأ في الإدخال',
        message: 'يرجى إدخال الطول بشكل صحيح (أكبر من 0)',
        successful: false,
      );
      return false;
    }

    if (weight == null || weight <= 0) {
      customSnackBar(
        title: 'خطأ في الإدخال',
        message: 'يرجى إدخال الوزن بشكل صحيح (أكبر من 0)',
        successful: false,
      );
      return false;
    }

    if (waist == null || waist <= 0) {
      customSnackBar(
        title: 'خطأ في الإدخال',
        message: 'يرجى إدخال محيط الوسط بشكل صحيح (أكبر من 0)',
        successful: false,
      );
      return false;
    }

    if (hip == null || hip <= 0) {
      customSnackBar(
        title: 'خطأ في الإدخال',
        message: 'يرجى إدخال محيط الحوض بشكل صحيح (أكبر من 0)',
        successful: false,
      );
      return false;
    }

    if (waist >= hip) {
      customSnackBar(
        title: 'خطأ في الإدخال',
        message: 'محيط الوسط يجب أن يكون أقل من محيط الحوض',
        successful: false,
      );
      return false;
    }

    return true;
  }

  /// Calculate body composition
  Future<void> calculateBodyComposition() async {
    if (!_validateInputs()) return;

    isCalculating.value = true;

    try {
      // Simulate calculation delay for better UX
      await Future.delayed(const Duration(milliseconds: 500));

      final model = BodyCompositionModel(
        gender: selectedGender.value,
        height: double.parse(heightController.text),
        weight: double.parse(weightController.text),
        waistCircumference: double.parse(waistController.text),
        hipCircumference: double.parse(hipController.text),
      );

      bodyCompositionResult.value = model;
      showResults.value = true;
      _saveData();

      customSnackBar(
        title: 'تم الحساب بنجاح',
        message: 'تم حساب مؤشرات الجسم بنجاح',
        successful: true,
      );
    } catch (e) {
      customSnackBar(
        title: 'خطأ في الحساب',
        message: 'حدث خطأ أثناء حساب المؤشرات: $e',
        successful: false,
      );
    } finally {
      isCalculating.value = false;
    }
  }

  /// Clear all inputs
  void clearInputs() {
    heightController.clear();
    weightController.clear();
    waistController.clear();
    hipController.clear();
    selectedGender.value = 'ذكر';
    showResults.value = false;
    bodyCompositionResult.value = null;
    _storage.remove(_storageKey);
    
    customSnackBar(
      title: 'تم المسح',
      message: 'تم مسح جميع البيانات',
      successful: true,
    );
  }

  /// Reset results
  void resetResults() {
    showResults.value = false;
    bodyCompositionResult.value = null;
  }

  /// Get BMI range text
  String getBMIRangeText(BMICategory category) {
    switch (category) {
      case BMICategory.underweight:
        return 'أقل من 18.5';
      case BMICategory.normal:
        return '18.5 - 24.9';
      case BMICategory.overweight:
        return '25 - 29.9';
      case BMICategory.obesityGradeI:
        return '30 - 34.9';
      case BMICategory.obesityGradeII:
        return '35 - 39.9';
      case BMICategory.obesityGradeIII:
        return '40 أو أكثر';
    }
  }

  /// Get WHR range text
  String getWHRRangeText(WHRRiskLevel riskLevel, String gender) {
    if (gender.toLowerCase() == 'ذكر') {
      switch (riskLevel) {
        case WHRRiskLevel.lowRisk:
          return 'أقل من 0.95';
        case WHRRiskLevel.moderateRisk:
          return '0.95 - 1.0';
        case WHRRiskLevel.highRisk:
          return 'أكثر من 1.0';
      }
    } else {
      switch (riskLevel) {
        case WHRRiskLevel.lowRisk:
          return 'أقل من 0.8';
        case WHRRiskLevel.moderateRisk:
          return '0.8 - 0.95';
        case WHRRiskLevel.highRisk:
          return 'أكثر من 0.95';
      }
    }
  }
}
