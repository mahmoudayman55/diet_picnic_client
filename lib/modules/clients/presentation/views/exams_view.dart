import 'dart:developer';

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
        title: "المسابقات والجوائز",
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
                  Tab(text: "المسابقات المتاحة"),
                  Tab(text: "نتائجي السابقة"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildExamsList(context, controller),
                    _buildSubmissionsList(context, controller),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildExamsList(BuildContext context, ExamsController controller) {
    final availableExams = controller.availableExams;
    return RefreshIndicator(
      onRefresh: () => controller.refreshAll(),
      child: availableExams.isEmpty
          ? ListView(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                const Center(child: Text("لا توجد مسابقات متاحة حاليا")),
              ],
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: availableExams.length,
              itemBuilder: (context, index) {
                final exam = availableExams[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: CustomColors.borderColor,
                      width: 1,
                    ),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Info Section
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Status Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: exam.isActive
                                        ? Colors.green.withOpacity(0.1)
                                        : Colors.grey.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    exam.isActive ? "نشط" : "غير متاح",
                                    style: TextStyle(
                                      color: exam.isActive
                                          ? Colors.green
                                          : Colors.grey,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  exam.title,
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${exam.questions.length} سؤال • جوائز مميزة",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                        color: Colors.grey.shade600,
                                        fontSize: 11,
                                      ),
                                ),
                                const Spacer(),
                                const SizedBox(height: 12),
                                // Compact Styled Button
                                Material(
                                  color: exam.isActive
                                      ? CustomColors.selectedNavBarColor
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(10),
                                  child: InkWell(
                                    onTap: exam.isActive
                                        ? () {
                                            Get.toNamed(
                                                AppConstants.examTestPage,
                                                arguments: exam);
                                          }
                                        : null,
                                    borderRadius: BorderRadius.circular(10),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            exam.isActive
                                                ? "ابدأ الآن"
                                                : "غير متاح",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium!
                                                .copyWith(color: Colors.white),
                                          ),
                                          const SizedBox(width: 4),
                                          if (exam.isActive)
                                            const Icon(Icons.arrow_back,
                                                size: 14, color: Colors.white),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Thumbnail Image
                        Container(
                          width: 120,
                          decoration: BoxDecoration(
                            color: CustomColors.mainColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                if (exam.image.isNotEmpty)
                                  Image.network(
                                    exam.image,
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                    width: double.infinity,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Center(
                                                child: Icon(Icons.quiz_outlined,
                                                    color: Colors.white)),
                                  )
                                else
                                  const Center(
                                      child: Icon(
                                    Icons.quiz_outlined,
                                    color: Colors.white,
                                    size: 50,
                                  )),
                                if (!exam.isActive)
                                  Positioned.fill(
                                    child: Container(
                                      color: Colors.black.withOpacity(0.3),
                                      child: const Center(
                                        child: Icon(Icons.lock_outline,
                                            color: Colors.white, size: 24),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildSubmissionsList(
      BuildContext context, ExamsController controller) {
    return RefreshIndicator(
      onRefresh: () => controller.refreshAll(),
      child: controller.userSubmissions.isEmpty
          ? ListView(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                const Center(child: Text("لم تقم بتأدية أي اختبارات بعد")),
              ],
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: controller.userSubmissions.length,
              itemBuilder: (context, index) {
                final submission = controller.userSubmissions[index];
                final exam = controller.allExams.firstWhereOrNull(
                  (e) => e.id == submission.examId,
                );
                log(exam.toString());

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: CustomColors.borderColor,
                      width: 1,
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
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
                            'date': submission.submittedAt,
                          },
                        );
                      },
                      borderRadius: BorderRadius.circular(18),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Content
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    // Score Badge
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: CustomColors.selectedNavBarColor
                                            .withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          "${submission.score}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium!
                                              .copyWith(
                                                  color:
                                                      CustomColors.mainColor),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          //  Text(exam!.title.toString()),
                                          Text(
                                            exam?.title ?? submission.examTitle,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            "${submission.submittedAt.day}/${submission.submittedAt.month}/${submission.submittedAt.year}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displaySmall
                                                ?.copyWith(
                                                  color: Colors.grey,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Small Thumbnail on the right
                            Container(
                              width: 80,
                              decoration: BoxDecoration(
                                color: CustomColors.mainColor,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  bottomLeft: Radius.circular(18),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  bottomLeft: Radius.circular(18),
                                ),
                                child: exam?.image != null &&
                                        exam!.image.isNotEmpty
                                    ? Image.network(
                                        exam.image,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.quiz_outlined,
                                                    size: 20,
                                                    color: Colors.white),
                                      )
                                    : const Icon(Icons.quiz_outlined,
                                        size: 20, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
