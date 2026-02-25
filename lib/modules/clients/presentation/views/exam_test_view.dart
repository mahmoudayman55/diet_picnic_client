import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../components/quetsion_select_widgets.dart';
import '../../../../core/custom_colors.dart';
import '../controllers/exam_test_controller.dart';

class ExamTestView extends StatelessWidget {
  const ExamTestView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExamTestController>();
    final pageController = PageController();

    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          final currentIdx = controller.currentQuestionIndex.value + 1;
          final total = controller.totalQuestions;
          final answered = controller.answers.where((a) => a != -1).length;

          return Column(
            children: [
              // ✅ Custom Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "$answered/$total أجيب عليه",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    Text(
                      "السؤال $currentIdx من $total",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ],
                ),
              ),

              // ✅ Thin Progress Indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: LinearProgressIndicator(
                  value: currentIdx / total,
                  backgroundColor: Colors.grey.shade200,
                  color: CustomColors.selectedNavBarColor,
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: total,
                  itemBuilder: (context, index) {
                    final question = controller.exam.questions[index];
                    return ExamQuestionWidget(
                      question: question.title,
                      options: question.options,
                      selectedOption: controller.answers[index] == -1
                          ? null
                          : controller.answers[index],
                      onSelect: (optionIndex) =>
                          controller.setAnswer(index, optionIndex),
                    );
                  },
                ),
              ),

              // ✅ Navigation Buttons
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    if (controller.currentQuestionIndex.value > 0)
                      Expanded(
                        child: TextButton(
                          onPressed: () =>
                              controller.prevQuestion(pageController),
                          child: Text(
                            "السابق",
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ),
                      ),
                    if (controller.currentQuestionIndex.value > 0)
                      const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.selectedNavBarColor,
                          minimumSize: const Size(double.infinity, 54),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                if (controller.isLastQuestion) {
                                  _showFinishConfirmation(context, controller);
                                } else {
                                  controller.nextQuestion(pageController);
                                }
                              },
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text(
                                controller.isLastQuestion ? "إنهاء" : "التالي",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _showFinishConfirmation(
      BuildContext context, ExamTestController controller) {
    final answeredCount = controller.answers.where((a) => a != -1).length;
    final totalCount = controller.totalQuestions;

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "تأكيد الإنهاء",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "هل أنت متأكد من إنهاء الاختبار؟",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 12),
            Text(
              "لقد أجبت على $answeredCount من $totalCount سؤال",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: answeredCount < totalCount
                        ? Colors.orange
                        : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "إلغاء",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.selectedNavBarColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Get.back();
              controller.submitTest();
            },
            child: Text(
              "تأكيد",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
