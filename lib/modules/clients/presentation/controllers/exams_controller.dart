import 'package:get/get.dart';
import '../../../../components/custom_snack_bar.dart';
import '../../../../controller/user_controller.dart';
import '../../domain/entities/exam_entities.dart';
import '../../domain/repositories/exam_repository.dart';

class ExamsController extends GetxController {
  final ExamRepository _repository;

  ExamsController(this._repository);

  final RxList<ExamEntity> allAccessibleExams = <ExamEntity>[].obs;
  final RxList<ExamEntity> allExams = <ExamEntity>[].obs;
  final RxList<ExamSubmissionEntity> userSubmissions =
      <ExamSubmissionEntity>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    refreshAll();
  }

  Future<void> fetchExams() async {
    try {
      isLoading.value = true;
      final fetchedExams = await _repository.getExams();
      allExams.assignAll(fetchedExams);
      final user = UserController.to.currentUser.value;
      if (user == null) {
        allAccessibleExams.value = [];
        return;
      }
      final isSubscribed = user.package != null;

      allAccessibleExams.value = fetchedExams.where((exam) {
        if (exam.availability == ExamAvailability.all) return true;
        if (isSubscribed) {
          return exam.availability == ExamAvailability.subscribers;
        } else {
          return exam.availability == ExamAvailability.nonSubscribers;
        }
      }).toList();
    } catch (e) {
      showCustomSnackbar(
          title: 'Error',
          message: 'Failed to load exams: $e',
          successful: false);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserSubmissions() async {
    try {
      final user = UserController.to.currentUser.value;
      if (user == null) return;

      userSubmissions.value = await _repository.getSubmissions(user.id);
    } catch (e) {
      showCustomSnackbar(
          title: 'Error',
          message: 'Failed to load your results: $e',
          successful: false);
    }
  }

  Future<void> refreshAll() async {
    await fetchUserSubmissions();
    await fetchExams();
    await _fetchMissingSubmissionExams();
  }

  /// Fetches exams referenced by submissions but not in [allExams]
  /// (e.g. exams that were hidden/deleted after the user submitted).
  Future<void> _fetchMissingSubmissionExams() async {
    final loadedIds = allExams.map((e) => e.id).toSet();
    final missingIds = userSubmissions
        .map((s) => s.examId)
        .where((id) => !loadedIds.contains(id))
        .toSet();

    for (final id in missingIds) {
      try {
        final exam = await _repository.getExamById(id);
        if (exam != null) {
          allExams.add(exam);
        }
      } catch (_) {
        // Silently ignore — exam may have been hard-deleted from Firestore.
      }
    }
  }

  List<ExamEntity> get availableExams {
    final takenExamIds = userSubmissions.map((s) => s.examId).toSet();
    return allAccessibleExams
        .where((exam) => !takenExamIds.contains(exam.id))
        .toList();
  }
}
