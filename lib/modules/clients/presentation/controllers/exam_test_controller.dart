import 'package:diet_picnic_client/components/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/user_controller.dart';
import '../../domain/entities/exam_entities.dart';
import '../../domain/repositories/exam_repository.dart';
import 'exams_controller.dart';
import '../../data/models/exam_models.dart';

class ExamTestController extends GetxController {
  final ExamRepository _repository;
  final ExamEntity exam;

  ExamTestController(this._repository, this.exam);

  final RxInt currentQuestionIndex = 0.obs;
  final RxList<int> answers = <int>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize answers with -1 (not answered)
    answers.value = List.filled(exam.questions.length, -1);
  }

  int get totalQuestions => exam.questions.length;
  bool get isLastQuestion => currentQuestionIndex.value == totalQuestions - 1;

  void setAnswer(int questionIndex, int optionIndex) {
    answers[questionIndex] = optionIndex;
    update();
  }

  void nextQuestion(PageController pageController) {
    if (isLastQuestion) {
      // Logic for showing confirmation in view
    } else {
      currentQuestionIndex.value++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void prevQuestion(PageController pageController) {
    if (currentQuestionIndex.value > 0) {
      currentQuestionIndex.value--;
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> submitTest() async {
    try {
      isLoading.value = true;

      final user = UserController.to.currentUser.value;

      // ── Bug fix #1: Only block re-submission for real client submissions
      // (isAdminTest == false). Admin test submissions must not prevent the
      // real client from taking the exam.
      if (user != null) {
        final submissions = await _repository.getSubmissions(user.id);
        if (submissions.any(
            (s) => s.examId == exam.id && s.isAdminTest == false)) {
          showCustomSnackbar(
              title: 'تنبيه',
              message: 'لقد قمت بتأدية هذا الاختبار بالفعل',
              successful: false);
          Get.offAllNamed('/');
          return;
        }
      }

      // ── Calculate score (number of correct answers)
      int correctCount = 0;
      for (int i = 0; i < exam.questions.length; i++) {
        if (answers[i] == exam.questions[i].correctAnswerIndex) {
          correctCount++;
        }
      }
      final score = correctCount;

      // ── Bug fix #2: Full prize resolution per spec (Section 5.2)
      // Determine subscription state from the client profile.
      final userPackage = user?.package;
      final isSubscriber =
          userPackage != null && userPackage.id.isNotEmpty;
      final clientPackageId = isSubscriber ? userPackage.id : null;

      PrizeEntity? wonPrize;

      for (final prize in exam.prizes) {
        // Step 1 – Score range check
        if (score < prize.minScore || score > prize.maxScore) continue;

        // Step 2 – Availability + package membership check
        final av = prize.availability;

        if (av == ExamAvailability.nonSubscribers) {
          // Prize is for non-subscribers only
          if (!isSubscriber) {
            wonPrize = prize;
            break;
          }
        } else if (av == ExamAvailability.subscribers) {
          // Prize requires active subscription AND package in the list
          if (isSubscriber &&
              prize.packageIds.contains(clientPackageId)) {
            wonPrize = prize;
            break;
          }
        } else {
          // ExamAvailability.all — any client qualifies if score matches,
          // but respect packageIds if the list is non-empty.
          if (prize.packageIds.isEmpty ||
              (isSubscriber &&
                  prize.packageIds.contains(clientPackageId)) ||
              !isSubscriber) {
            wonPrize = prize;
            break;
          }
        }
      }

      // ── Bug fix #3: Store the *prize's* package IDs/names in the submission
      // (comma-joined), not the user's own package.
      final submission = ExamSubmissionModel(
        id: '',
        examId: exam.id,
        examTitle: exam.title,
        clientId: user?.id ?? 'anonymous',
        clientName: user?.name ?? 'Anonymous',
        score: score,
        totalQuestions: totalQuestions,
        packageId: wonPrize?.packageIds.join(', '),
        packageName: wonPrize?.packageNames.join(', '),
        prizeWon: wonPrize?.title,
        submittedAt: DateTime.now(),
        isAdminTest: false,
        answers: answers.toList(),
      );

      await _repository.submitExam(submission);

      // Refresh ExamsController to remove this exam from available list
      if (Get.isRegistered<ExamsController>()) {
        Get.find<ExamsController>().refreshAll();
      }

      // Navigate to results or show success
      Get.offNamed('/exam-results', arguments: {
        'score': score,
        'totalQuestions': totalQuestions,
        'prize': wonPrize,
        'exam': exam,
        'date': submission.submittedAt,
      });
    } catch (e) {
      showCustomSnackbar(
          title: 'Error',
          message: 'Failed to submit exam: $e',
          successful: false);
    } finally {
      isLoading.value = false;
    }
  }
}
