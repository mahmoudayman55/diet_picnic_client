enum ExamAvailability {
  all,
  subscribers,
  nonSubscribers,
}

class ExamEntity {
  final String id;
  final String title;
  final String image;
  final bool isActive;
  final bool isVisible;
  final ExamAvailability availability;
  final List<QuestionEntity> questions;
  final List<PrizeEntity> prizes;
  final String prizeImage;

  ExamEntity({
    required this.id,
    required this.title,
    required this.image,
    required this.isActive,
    required this.isVisible,
    required this.availability,
    required this.questions,
    required this.prizes,
    this.prizeImage = '',
  });
}

class QuestionEntity {
  final String title;
  final List<String> options;
  final int correctIndex;

  QuestionEntity({
    required this.title,
    required this.options,
    required this.correctIndex,
  });
}

class PrizeEntity {
  final String id;
  final String title;
  final String image;
  final int minScore;
  final int maxScore;
  final ExamAvailability availability;
  final List<String> packageIds;

  PrizeEntity({
    required this.id,
    required this.title,
    required this.image,
    required this.minScore,
    required this.maxScore,
    required this.availability,
    required this.packageIds,
  });
}

class ExamSubmissionEntity {
  final String id;
  final String examId;
  final String examTitle;
  final String clientId;
  final String clientName;
  final int score;
  final int totalQuestions;
  final String? packageId;
  final String? packageName;
  final String? prizeWon;
  final DateTime submittedAt;
  final bool isAdminTest;
  final List<int?> answers;

  ExamSubmissionEntity({
    required this.id,
    required this.examId,
    required this.examTitle,
    required this.clientId,
    required this.clientName,
    required this.score,
    required this.totalQuestions,
    this.packageId,
    this.packageName,
    this.prizeWon,
    required this.submittedAt,
    this.isAdminTest = false,
    required this.answers,
  });
}
