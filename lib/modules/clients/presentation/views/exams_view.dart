import 'package:diet_picnic_client/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/app_constants.dart';
import '../../../../core/custom_colors.dart';
import '../../domain/entities/exam_entities.dart';
import '../controllers/exams_controller.dart';

class ExamsView extends StatelessWidget {
  const ExamsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExamsController>();

    return Scaffold(
      appBar: const CustomAppBar(
        title: "الاختبارات والجوائز",
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                indicatorColor: CustomColors.selectedNavBarColor,
                labelColor: CustomColors.selectedNavBarColor,
                unselectedLabelColor: Colors.grey,
                labelStyle: Theme.of(context).textTheme.displayMedium,
                tabs: const [
                  Tab(text: "الاختبارات المتاحة"),
                  Tab(text: "نتائجي السابقة"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildExamsList(controller),
                    _buildSubmissionsList(controller),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildExamsList(ExamsController controller) {
    final availableExams = controller.availableExams;
    if (availableExams.isEmpty) {
      return const Center(child: Text("لا توجد اختبارات متاحة حاليا"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: availableExams.length,
      itemBuilder: (context, index) {
        final exam = availableExams[index];
        return Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (exam.image.isNotEmpty)
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    exam.image,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(height: 150, color: Colors.grey.shade200),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam.title,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(fontSize: 20),
                    ),
                    // const SizedBox(height: 8),
                    // Text(
                    //   "${exam.questions.length} سؤال • ${exam.prizes.length} جوائز محتملة",
                    //   style: Theme.of(context)
                    //       .textTheme
                    //       .displayMedium
                    //       !.copyWith(color: Colors.grey),
                    // ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: exam.isActive
                              ? CustomColors.selectedNavBarColor
                              : Colors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: exam.isActive
                            ? () {
                                Get.toNamed(AppConstants.examTestPage,
                                    arguments: exam);
                              }
                            : null,
                        child: Text(
                            exam.isActive ? "ابدأ الاختبار" : "غير متاح حالياً",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSubmissionsList(ExamsController controller) {
    if (controller.userSubmissions.isEmpty) {
      return const Center(child: Text("لم تقم بتأدية أي اختبارات بعد"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.userSubmissions.length,
      itemBuilder: (context, index) {
        final submission = controller.userSubmissions[index];
        final exam = controller.allAccessibleExams.firstWhereOrNull(
          (e) => e.id == submission.examId,
        );
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: CustomColors.selectedNavBarColor,
            child: Text("${submission.score}",
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
          title: Text(exam?.title ?? "اختبار"),
          subtitle: Text(
            "${submission.submittedAt.day}/${submission.submittedAt.month}/${submission.submittedAt.year}",
            style: Theme.of(context)
                .textTheme
                .displaySmall
                ?.copyWith(fontSize: 12),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${submission.score} / ${submission.totalQuestions}",
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: CustomColors.selectedNavBarColor,
                    ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
          onTap: () {
            PrizeEntity? wonPrize;
            if (submission.prizeWon != null && exam != null) {
              wonPrize = exam.prizes.firstWhereOrNull(
                (p) => p.title == submission.prizeWon,
              );
            }

            Get.toNamed(
              '/exam-results',
              arguments: {
                'score': submission.score,
                'totalQuestions': submission.totalQuestions,
                'prize': wonPrize,
                'exam': exam,
              },
            );
          },
        );
      },
    );
  }
}
