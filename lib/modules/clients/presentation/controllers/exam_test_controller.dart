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

      // Calculation check
      final user = UserController.to.currentUser.value;
      if (user != null) {
        final submissions = await _repository.getSubmissions(user.id);
        if (submissions.any((s) => s.examId == exam.id)) {
          showCustomSnackbar(
              title: 'Alert',
              message: 'لقد قمت بتأدية هذا الاختبار بالفعل',
              successful: false);
          Get.offAllNamed('/'); // Go back to home
          return;
        }
      }

      // Calculate score
      int correctCount = 0;
      for (int i = 0; i < exam.questions.length; i++) {
        if (answers[i] == exam.questions[i].correctIndex) {
          correctCount++;
        }
      }

      final score = correctCount;

      // Find Won Prize
      PrizeEntity? wonPrize;

      if (user != null) {
        final isSubscribed = user.package != null;
        final userPackageId = user.package?.id;

        for (final prize in exam.prizes) {
          if (score >= prize.minScore && score <= prize.maxScore) {
            // Check availability
            bool eligible = false;
            if (prize.availability == ExamAvailability.all) {
              eligible = true;
            } else if (isSubscribed &&
                prize.availability == ExamAvailability.subscribers) {
              eligible = true;
            } else if (!isSubscribed &&
                prize.availability == ExamAvailability.nonSubscribers) {
              eligible = true;
            }

            // Check Package IDs if applicable
            if (eligible &&
                (prize.availability == ExamAvailability.subscribers ||
                    prize.availability == ExamAvailability.all)) {
              if (prize.packageIds.isNotEmpty &&
                  !prize.packageIds.contains(userPackageId)) {
                eligible = false;
              }
            }

            if (eligible) {
              wonPrize = prize;
              break; // Take the first eligible prize found for the score
            }
          }
        }
      }

      // Create Submission
      final submission = ExamSubmissionModel(
        id: '', // Firestore sets this
        examId: exam.id,
        examTitle: exam.title,
        clientId: user?.id ?? 'anonymous',
        clientName: user?.name ?? 'Anonymous',
        score: score,
        totalQuestions: totalQuestions,
        packageId: user?.package?.id,
        packageName: user?.package?.name,
        prizeWon: wonPrize?.title, // Dashboard likely wants the name
        submittedAt: DateTime.now(),
        isAdminTest: false, // Defaulting to false for clients
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
