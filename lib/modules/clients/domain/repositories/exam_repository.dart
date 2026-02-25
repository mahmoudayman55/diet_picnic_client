import '../entities/exam_entities.dart';

abstract class ExamRepository {
  Future<List<ExamEntity>> getExams();

  Future<void> submitExam(ExamSubmissionEntity submission);

  Future<List<ExamSubmissionEntity>> getSubmissions(String userId);
}
