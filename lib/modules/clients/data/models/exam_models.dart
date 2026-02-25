import '../../domain/entities/exam_entities.dart';

class ExamModel extends ExamEntity {
  ExamModel({
    required super.id,
    required super.title,
    required super.image,
    required super.isActive,
    required super.isVisible,
    required super.availability,
    required super.questions,
    required super.prizes,
    super.prizeImage = '',
  });

  factory ExamModel.fromJson(Map<String, dynamic> json, String id) {
    return ExamModel(
      id: id,
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      isActive: json['isActive'] ?? true,
      isVisible: json['isVisible'] ?? true,
      availability: ExamAvailability.values.firstWhere(
        (e) => e.name == (json['availability'] ?? 'all'),
        orElse: () => ExamAvailability.all,
      ),
      questions: (json['questions'] as List? ?? [])
          .map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
          .toList(),
      prizes: (json['prizes'] as List? ?? [])
          .map((p) => PrizeModel.fromJson(p as Map<String, dynamic>))
          .toList(),
      prizeImage: json['prizeImage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'image': image,
      'isActive': isActive,
      'isVisible': isVisible,
      'availability': availability.name,
      'questions': questions.map((q) => (q as QuestionModel).toJson()).toList(),
      'prizes': prizes.map((p) => (p as PrizeModel).toJson()).toList(),
      'prizeImage': prizeImage,
    };
  }
}

class QuestionModel extends QuestionEntity {
  QuestionModel({
    required super.title,
    required super.options,
    required super.correctIndex,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      title: json['title'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctIndex: json['correctIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'options': options,
      'correctIndex': correctIndex,
    };
  }
}

class PrizeModel extends PrizeEntity {
  PrizeModel({
    required super.id,
    required super.title,
    required super.image,
    required super.minScore,
    required super.maxScore,
    required super.availability,
    required super.packageIds,
  });

  factory PrizeModel.fromJson(Map<String, dynamic> json) {
    return PrizeModel(
      id: json['id'] ?? '',
      title: json['prizeName'] ?? '',
      image: json['image'] ?? '',
      minScore: json['minScore'] ?? 0,
      maxScore: json['maxScore'] ?? 100,
      availability: ExamAvailability.values.firstWhere(
        (e) => e.name == (json['availability'] ?? 'all'),
        orElse: () => ExamAvailability.all,
      ),
      packageIds: List<String>.from(json['packageIds'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prizeName': title,
      'image': image,
      'minScore': minScore,
      'maxScore': maxScore,
      'availability': availability.name,
      'packageIds': packageIds,
    };
  }
}

class ExamSubmissionModel extends ExamSubmissionEntity {
  ExamSubmissionModel({
    required super.id,
    required super.examId,
    required super.examTitle,
    required super.clientId,
    required super.clientName,
    required super.score,
    required super.totalQuestions,
    super.packageId,
    super.packageName,
    super.prizeWon,
    required super.submittedAt,
    super.isAdminTest = false,
    required super.answers,
  });

  factory ExamSubmissionModel.fromJson(Map<String, dynamic> json, String id) {
    return ExamSubmissionModel(
      id: id,
      examId: json['examId'] ?? '',
      examTitle: json['examTitle'] ?? '',
      clientId: json['clientId'] ?? '',
      clientName: json['clientName'] ?? '',
      score: json['score'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      packageId: json['packageId'],
      packageName: json['packageName'],
      prizeWon: json['prizeWon'],
      submittedAt: json['submittedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['submittedAt'] as int)
          : DateTime.now(),
      isAdminTest: json['isAdminTest'] ?? false,
      answers: (json['answers'] as List<dynamic>? ?? [])
          .map((a) => a as int?)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'examId': examId,
      'examTitle': examTitle,
      'clientId': clientId,
      'clientName': clientName,
      'score': score,
      'totalQuestions': totalQuestions,
      'packageId': packageId,
      'packageName': packageName,
      'prizeWon': prizeWon,
      'submittedAt': submittedAt.millisecondsSinceEpoch,
      'isAdminTest': isAdminTest,
      'answers': answers,
    };
  }
}
