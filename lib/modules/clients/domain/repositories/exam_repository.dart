import '../entities/exam_entities.dart';

abstract class ExamRepository {
  Future<List<ExamEntity>> getExams();

  /// Fetches a single exam by [id] regardless of its visibility flag.
  Future<ExamEntity?> getExamById(String id);

  Future<void> submitExam(ExamSubmissionEntity submission);

  Future<List<ExamSubmissionEntity>> getSubmissions(String userId);
}
