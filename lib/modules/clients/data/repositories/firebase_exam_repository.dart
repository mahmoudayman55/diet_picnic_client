import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/exam_entities.dart';
import '../../domain/repositories/exam_repository.dart';
import '../models/exam_models.dart';

class FirebaseExamRepository implements ExamRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<ExamModel>> getExams() async {
    final snapshot = await _firestore
        .collection('exams')
        .where('isVisible', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => ExamModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> submitExam(ExamSubmissionEntity submission) async {
    if (submission is ExamSubmissionModel) {
      await _firestore.collection('exam_submissions').add(submission.toJson());
    } else {
      // Fallback if it's just the entity
      await _firestore.collection('exam_submissions').add({
        'examId': submission.examId,
        'examTitle': submission.examTitle,
        'clientId': submission.clientId,
        'clientName': submission.clientName,
        'score': submission.score,
        'totalQuestions': submission.totalQuestions,
        'packageId': submission.packageId,
        'packageName': submission.packageName,
        'prizeWon': submission.prizeWon,
        'submittedAt': submission.submittedAt.millisecondsSinceEpoch,
        'isAdminTest': submission.isAdminTest,
        'answers': submission.answers,
      });
    }
  }

  @override
  Future<List<ExamSubmissionModel>> getSubmissions(String userId) async {
    final snapshot = await _firestore
        .collection('exam_submissions')
        .where('clientId', isEqualTo: userId)
        .orderBy('submittedAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ExamSubmissionModel.fromJson(doc.data(), doc.id))
        .toList();
  }
}
