import 'package:diet_picnic_client/components/quetsion_select_widgets.dart';
import 'package:diet_picnic_client/components/single_select_chip.dart';
import 'package:diet_picnic_client/controller/quiz_controller.dart';
import 'package:diet_picnic_client/controller/user_controller.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewCustomerQuestionnaireQuizView extends StatelessWidget {
  const NewCustomerQuestionnaireQuizView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NewCustomerQuizController());
    final pageController = PageController();

    return Scaffold(
      appBar: AppBar(
        title: Text("التاريخ الطبى",
            style: Theme.of(context)
                .textTheme
                .displayLarge
                ),
        centerTitle: true,
      ),
      body: Obx(() {
        return Column(
          children: [
            // ✅ Progress Indicator
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LinearProgressIndicator(
                value: (controller.currentQuestionIndex.value + 1) /
                    controller.totalQuestions,
                backgroundColor: Colors.grey.shade300,
                color: CustomColors.selectedNavBarColor,
                minHeight: 8,
                borderRadius: BorderRadius.circular(12),
              ),
            ),

            Expanded(
              child: Obx(
                    () => PageView(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // 🩺 هل تعاني من أمراض مزمنة؟
                    QuestionMultiSelectWidget(
                      question: "هل تعاني من أمراض مزمنة؟",
                      options: controller.chronicDiseasesOptions,
                      selectedOptions: controller.selectedChronicDiseases,
                      onSelect: controller.toggleChronicDisease,
                    ),

                    // 👨‍👩‍👧 أمراض مزمنة عائلية
                    QuestionMultiSelectWidget(
                      question: "هل أحد من العائلة يعاني من أمراض مزمنة؟",
                      options: controller.familyChronicDiseasesOptions,
                      selectedOptions: controller.selectedFamilyChronicDiseases,
                      onSelect: controller.toggleFamilyDisease,
                    ),

                    // 🏋️‍♀️ أدوات رياضية في البيت
                    QuestionMultiSelectWidget(
                      question: "هل عندك أدوات رياضية في البيت؟",
                      options: controller.homeEquipmentOptions,
                      selectedOptions: controller.selectedHomeEquipment,
                      onSelect: controller.toggleHomeEquipment,
                    ),

                    // ♀️ اضطرابات الدورة الشهرية (للإناث فقط)
                    if (UserController.to.currentUser.value!.gender == 'أنثى')
                      QuestionSingleSelectWidget<bool>(
                        question: "هل فيه أي اضطرابات في الدورة الشهرية؟",
                        options: const [true, false],
                        selectedOption: controller.hasMenstrualDisorder.value,
                        labelBuilder: (item) => item ? "نعم" : "لا",
                        onSelect: controller.setMenstrualDisorder,
                      ),

                    // 🤰 هل أنتِ حامل حاليًا؟ (للإناث فقط)
                    if (UserController.to.currentUser.value!.gender == 'أنثى')
                      QuestionSingleSelectWidget<bool>(
                        question: "هل أنتِ حامل حاليًا؟",
                        options: const [true, false],
                        selectedOption: controller.isPregnant.value,
                        labelBuilder: (item) => item ? "نعم" : "لا",
                        onSelect: controller.setPregnant,
                      ),

                    // 🍼 هل ترضعين طبيعيًا الآن؟ (للإناث فقط)
                    if (UserController.to.currentUser.value!.gender == 'أنثى')
                      QuestionSingleSelectWidget<bool>(
                        question: "هل ترضعين طبيعيًا الآن؟",
                        options: const [true, false],
                        selectedOption: controller.isBreastFeeding.value,
                        labelBuilder: (item) => item ? "نعم" : "لا",
                        onSelect: controller.setBreastFeeding,
                      ),

                    // 🔪 عمليات جراحية
                    QuestionSingleSelectWidget<bool>(
                      question: "هل عملت أي عمليات قبل كده؟",
                      options: const [true, false],
                      selectedOption: controller.hadSurgery.value,
                      labelBuilder: (item) => item ? "نعم" : "لا",
                      onSelect: controller.setSurgery,
                    ),

                    // 💪 نزلت جيم قبل كده؟
                    QuestionSingleSelectWidget<bool>(
                      question: "هل نزلت جيم قبل كده؟",
                      options: const [true, false],
                      selectedOption: controller.wentToGym.value,
                      labelBuilder: (item) => item ? "نعم" : "لا",
                      onSelect: controller.setGym,
                    ),

                    // 🤕 إصابات سابقة
                    QuestionMultiSelectWidget(
                      question: "هل جالك إصابة قبل كده؟",
                      options: ["لا يوجد", ...controller.injuryOptions],
                      selectedOptions: controller.selectedInjuries,
                      onSelect: controller.toggleInjuries,
                    ),

                    // 💊 أدوية أو مكملات
                    QuestionMultiSelectWidget(
                      question: "هل تتناول أدوية أو فيتامينات أو مكملات؟",
                      options: ["لا يوجد", ...controller.medicationsOptions],
                      selectedOptions: controller.selectedMedications,
                      onSelect: controller.toggleMedications,
                    ),

                    // 😋 الجوع العاطفي
                    QuestionSingleSelectWidget<String>(
                      question:
                      "هل بيجيلك وقت تحس إنك جعان جدًا (الجوع العاطفي)؟ وإمتى؟",
                      options: controller.emotionalHangerOptions,
                      selectedOption: controller.selectedEmotionalHanger.value,
                      labelBuilder: (item) => item,
                      onSelect: controller.setEmotionalHanger,
                    ),

                    // ⚖️ تغير الوزن مؤخرًا
                    QuestionSingleSelectWidget<String>(
                      question: "هل حصل زيادة أو نقصان في الوزن بشكل مفاجئ آخر 3 شهور؟",
                      options: controller.weightChangeOptions,
                      selectedOption: controller.selectedWeightChange.value,
                      labelBuilder: (item) => item,
                      onSelect: controller.setWeightChange,
                    ),

                    // 💧 مقدار شرب الماء
                    QuestionSingleSelectWidget<String>(
                      question: "كم مقدار شربك للماء يوميًا؟",
                      options: controller.waterOptions,
                      selectedOption: controller.waterIntake.value,
                      labelBuilder: (item) => item,
                      onSelect: controller.setWaterIntake,
                    ),

                    // 🏃 النشاط البدني
                    QuestionSingleSelectWidget<String>(
                      question: "ما معدل ممارستك للنشاط البدني؟",
                      options: controller.activityOptions,
                      selectedOption: controller.selectedActivityLevel.value,
                      labelBuilder: (item) => item,
                      onSelect: controller.setActivityLevel,
                    ),
                  ],
                ),
              ),
            ),


            // ✅ Navigation Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (controller.currentQuestionIndex.value > 0)
                    Expanded(
                      child:             OutlinedButton(
                        onPressed: () =>
                            controller.prevQuestion(pageController),
                        child: Text("السابق",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(color: CustomColors.selectedNavBarColor)),
                        style: OutlinedButton.styleFrom(
                            side:
                            BorderSide(color: CustomColors.selectedNavBarColor)),
                      ),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.selectedNavBarColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22)),
                      ),
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                        controller.nextQuestion(pageController);
                      },
                      child:controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                        controller.isLastQuestion
                            ? "إنهاء"
                            : "التالي",style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
