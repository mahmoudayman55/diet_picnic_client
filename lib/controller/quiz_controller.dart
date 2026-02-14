import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_picnic_client/components/custom_snack_bar.dart';
import 'package:diet_picnic_client/controller/user_controller.dart';
import 'package:diet_picnic_client/models/questionnaire_answers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewCustomerQuizController extends GetxController {
  @override
  void onInit() {
    final answers = UserController.to.currentUser.value!.questionnaireAnswers;
    if (answers != null) {
      // ✅ قيم من نوع bool
      hadSurgery.value = answers.hadSurgery;
      hasMenstrualDisorder.value = answers.hasMenstrualDisorder;
      wentToGym.value = answers.wentToGym;

      // ✅ Lists
      selectedChronicDiseases.value = answers.chronicDiseases;
      selectedFamilyChronicDiseases.value = answers.familyChronicDiseases;
      selectedJointPain.value = answers.jointPain;
      selectedInjuries.value = answers.injuries;
      selectedHomeEquipment.value = answers.homeEquipment;
      selectedMedications.value = answers.medications;

      // ✅ Strings (nullable reactive)
      selectedEmotionalHanger.value = answers.emotionalHanger;
      selectedWeightChange.value = answers.weightChange;
      waterIntake.value = answers.waterIntake;
      selectedActivityLevel.value = answers.activityLevel;
      selectedSleep.value = answers.sleep;

      // ✅ الحمل والرضاعة من الـ User نفسه
      isPregnant.value =  UserController.to.currentUser.value!.isPregnant ?? false;
      isBreastFeeding.value =  UserController.to.currentUser.value!.isLactating ?? false;
    }

    super.onInit();
  }

  // ✅ Track current question
  final RxInt currentQuestionIndex = 0.obs;

  // ✅ Total number of questions
  final int totalQuestions = UserController.to.currentUser.value!.gender != 'أنثى'?11:14;

  // ✅ Reactive states for all questions
  final RxBool hadSurgery = false.obs;
  final RxList<String> selectedChronicDiseases = <String>[].obs;
  final RxList<String> selectedFamilyChronicDiseases = <String>[].obs;
  final RxBool smokes = false.obs;
  final RxString sleepHours = ''.obs;
  final RxString waterIntake = ''.obs;
  final RxString activityFrequency = ''.obs;
  final RxString onDiet = ''.obs;
  final RxString hasAllergy = ''.obs;
  final RxList<String> selectedJointPain = <String>[].obs;
  final RxList<String> selectedMedications = <String>[].obs;
  final RxList<String> selectedInjuries = <String>[].obs;
  final RxList<String> selectedHomeEquipment = <String>[].obs;
  final RxnBool hasMenstrualDisorder = RxnBool(false);
  final RxnBool wentToGym = RxnBool(false);
  final RxnString selectedEmotionalHanger = RxnString();
  final RxnString selectedWeightChange = RxnString();
  final RxnString selectedActivityLevel = RxnString();
  final RxnString selectedSleep = RxnString();
  // 🆕 الحمل والرضاعة (من الـ user)
  final RxBool isPregnant = false.obs;
  final RxBool isBreastFeeding = false.obs;
  void setPregnant(bool value) => isPregnant.value = value;
  void setBreastFeeding(bool value) => isBreastFeeding.value = value;

  // ✅ Options
  final yesNoOptions = ["نعم", "لا"].obs;

  final chronicDiseasesOptions = <String>[
    "لا يوجد",
    "نقرس",
    "روماتويد",
    "سكر 1",
    "سكر 2",
    "ضغط",
    "غدة",
    "مرض مناعي آخر",
  ].obs;

  final familyChronicDiseasesOptions = <String>[
    "لا يوجد",
    "مرض مناعي آخر",
    "نقرس",
    "روماتويد",
    "سكر 1",
    "سكر 2",
    "ضغط",
    "غدة",
  ].obs;

  final jointPainOptions = <String>[
    "لا يوجد",
    "الركبتين",
    "الرقبة",
    "أسفل الظهر",
    "الكتف",
    "الحوض",
  ].obs;

  final medicationsOptions = <String>["أدوية", "فيتامينات", "مكملات غذائية"].obs;

  final injuryOptions = <String>[
    "الرقبة",
    "اسفل الظهر",
    "الكتف",
    "المرفق",
    "الساعد",
    "الحوض",
    "الركبة",
    "الكاحل"
  ].obs;

  final emotionalHangerOptions =
      <String>["عشوائي", "بالليل", "بالنهار", "لا"].obs;

  final weightChangeOptions =
      <String>["اكثر من 15ك", "اكثر من 10ك", "اكثر من 5ك", "لا"].obs;

  final waterOptions =
      <String>["أقل من 5 أكواب", "من 5 إلى 10", "أكثر من 10"].obs;

  final activityOptions = <String>["منخفض", "متوسط", "عالي"].obs;

  final sleepOptions =
      <String>["اكثر من 8 ساعات", "من 6 لـ8ساعات", "أقل من 6 ساعات"].obs;

  final homeEquipmentOptions = <String>[
    "لا يوجد",
    "دمبلز",
    "بار",
    "شرائط مقاومة",
    "سوستة",
    "أجهزة أخرى"
  ].obs;
  final RxBool isLoading = false.obs;

  // ✅ Setters
  void setSurgery(bool value) => hadSurgery.value = value;
  void setSmokes(bool value) => smokes.value = value;
  void setSleepHours(String value) => sleepHours.value = value;
  void setWaterIntake(String value) => waterIntake.value = value;
  void setActivityFrequency(String value) => activityFrequency.value = value;
  void setOnDiet(String value) => onDiet.value = value;
  void setHasAllergy(String value) => hasAllergy.value = value;

  // New Setters
  void setMenstrualDisorder(bool? value) => hasMenstrualDisorder.value = value;
  void setGym(bool? value) => wentToGym.value = value;
  void setEmotionalHanger(String? value) => selectedEmotionalHanger.value = value;
  void setWeightChange(String? value) => selectedWeightChange.value = value;
  void setActivityLevel(String? value) => selectedActivityLevel.value = value;
  void setSleep(String? value) => selectedSleep.value = value;

  // ✅ Multi-select toggles (with “لا يوجد” logic)
  void toggleChronicDisease(String value) {
    if (value == "لا يوجد") {
      selectedChronicDiseases.clear();
      selectedChronicDiseases.add(value);
    } else {
      if (selectedChronicDiseases.contains("لا يوجد")) {
        selectedChronicDiseases.remove("لا يوجد");
      }
      selectedChronicDiseases.toggleValue(value);
    }
  }

  void toggleFamilyDisease(String value) {
    if (value == "لا يوجد") {
      selectedFamilyChronicDiseases.clear();
      selectedFamilyChronicDiseases.add(value);
    } else {
      if (selectedFamilyChronicDiseases.contains("لا يوجد")) {
        selectedFamilyChronicDiseases.remove("لا يوجد");
      }
      selectedFamilyChronicDiseases.toggleValue(value);
    }
  }

  void toggleJointPain(String value) {
    if (value == "لا يوجد") {
      selectedJointPain.clear();
      selectedJointPain.add(value);
    } else {
      if (selectedJointPain.contains("لا يوجد")) {
        selectedJointPain.remove("لا يوجد");
      }
      selectedJointPain.toggleValue(value);
    }
  }

  void toggleMedications(String value) {
    if (value == "لا يوجد") {
      selectedMedications.clear();
      selectedMedications.add(value);
    } else {
      if (selectedMedications.contains("لا يوجد")) {
        selectedMedications.remove("لا يوجد");
      }
      selectedMedications.toggleValue(value);
    }
  }

  void toggleInjuries(String value) {
    if (value == "لا يوجد") {
      selectedInjuries.clear();
      selectedInjuries.add(value);
    } else {
      if (selectedInjuries.contains("لا يوجد")) {
        selectedInjuries.remove("لا يوجد");
      }
      selectedInjuries.toggleValue(value);
    }
  }

  void toggleHomeEquipment(String value) {
    if (value == "لا يوجد") {
      selectedHomeEquipment.clear();
      selectedHomeEquipment.add(value);
    } else {
      if (selectedHomeEquipment.contains("لا يوجد")) {
        selectedHomeEquipment.remove("لا يوجد");
      }
      selectedHomeEquipment.toggleValue(value);
    }
  }

  // ✅ Navigation logic
  void nextQuestion(PageController controller) {
    if (currentQuestionIndex.value < totalQuestions - 1) {
      currentQuestionIndex.value++;
      controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      finishQuiz();
    }
  }

  void prevQuestion(PageController controller) {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
      controller.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  // ✅ Check if last question
  bool get isLastQuestion => currentQuestionIndex.value == totalQuestions - 1;

  Future<void> finishQuiz() async {
    final userController = UserController.to;
    final user = userController.currentUser.value;

    if (user == null) {
      customSnackBar(
        title: "خطأ",
        message: "لم يتم العثور على المستخدم الحالي ❌",
        successful: false,
      );
      return;
    }

    try {
      isLoading.value = true;

      // 🧩 Build QuestionnaireAnswers model
      final answers = QuestionnaireAnswers(
        chronicDiseases: selectedChronicDiseases.toList(),
        familyChronicDiseases: selectedFamilyChronicDiseases.toList(),
        jointPain: selectedJointPain.toList(),
        injuries: selectedInjuries.toList(),
        homeEquipment: selectedHomeEquipment.toList(),
        hasMenstrualDisorder: hasMenstrualDisorder.value ?? false,
        hadSurgery: hadSurgery.value,
        wentToGym: wentToGym.value ?? false,
        medications: selectedMedications.toList(),
        emotionalHanger: selectedEmotionalHanger.value ?? '',
        weightChange: selectedWeightChange.value ?? '',
        waterIntake: waterIntake.value,
        activityLevel: selectedActivityLevel.value ?? '',
        sleep: selectedSleep.value ?? '',
      );

      // 🧠 Update Firestore
      final docRef = FirebaseFirestore.instance.collection('clients').doc(user.id);

      await docRef.update({
        'questionnaire_answers': answers.toJson(),
        'is_pregnant': isPregnant.value,       // 🆕 تحديث قيم user نفسها
        'is_lactating': isBreastFeeding.value,
      });

      // 🧩 Update locally
      userController.currentUser.update((val) {
        if (val != null) {
          val.questionnaireAnswers = answers;
          val.isPregnant = isPregnant.value;
          val.isLactating = isBreastFeeding.value;
        }
      });

      Get.back();

      customSnackBar(
        title: "تم الحفظ",
        message: "تم تسجيل إجابات الاستبيان بنجاح ✅",
        successful: true,
      );
    } catch (e) {
      customSnackBar(
        title: "خطأ",
        message: "حدث خطأ أثناء حفظ البيانات: $e",
        successful: false,
      );
    } finally {
      isLoading.value = false;
    }
  }}
// 🧩 Helper extension for toggling
extension RxListToggle<T> on RxList<T> {
  void toggleValue(T value) {
    if (contains(value)) {
      remove(value);
    } else {
      add(value);
    }
  }
}
