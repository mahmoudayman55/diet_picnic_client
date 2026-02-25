import 'package:get/get.dart';
import '../../../../components/custom_snack_bar.dart';
import '../../../../controller/user_controller.dart';
import '../../domain/entities/exam_entities.dart';
import '../../domain/repositories/exam_repository.dart';

class ExamsController extends GetxController {
  final ExamRepository _repository;

  ExamsController(this._repository);

  final RxList<ExamEntity> allAccessibleExams = <ExamEntity>[].obs;
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
      final allExams = await _repository.getExams();

      final user = UserController.to.currentUser.value;
      if (user == null) {
        allAccessibleExams.value = [];
        return;
      }
      final isSubscribed = user.package != null;

      allAccessibleExams.value = allExams.where((exam) {
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
  }

  List<ExamEntity> get availableExams {
    final takenExamIds = userSubmissions.map((s) => s.examId).toSet();
    return allAccessibleExams
        .where((exam) => !takenExamIds.contains(exam.id))
        .toList();
  }
}
