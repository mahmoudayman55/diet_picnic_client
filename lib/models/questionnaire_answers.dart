class QuestionnaireAnswers {
  final List<String> chronicDiseases;
  final List<String> injuries;
  final List<String> familyChronicDiseases;
  final List<String> jointPain;
  final List<String> homeEquipment;
  final bool hasMenstrualDisorder;
  final bool hadSurgery;
  final bool wentToGym;

  final List<String> medications;
  final String emotionalHanger;
  final String weightChange;
  final String waterIntake;
  final String activityLevel;
  final String sleep;

  QuestionnaireAnswers({
    required this.chronicDiseases,
    required this.familyChronicDiseases,
    required this.jointPain,
    required this.injuries,
    required this.homeEquipment,
    required this.hasMenstrualDisorder,
    required this.hadSurgery,
    required this.wentToGym,
    required this.medications,
    required this.emotionalHanger,
    required this.weightChange,
    required this.waterIntake,
    required this.activityLevel,
    required this.sleep,
  });

  /// 🟢 من JSON
  factory QuestionnaireAnswers.fromJson(Map<String, dynamic> json) {
    return QuestionnaireAnswers(
      chronicDiseases: List<String>.from(json['chronic_diseases'] ?? []),
      familyChronicDiseases:
      List<String>.from(json['family_chronic_diseases'] ?? []),
      jointPain: List<String>.from(json['joint_pain'] ?? []),
      injuries: List<String>.from(json['injuries'] ?? []),
      homeEquipment: List<String>.from(json['home_equipment'] ?? []),
      hasMenstrualDisorder: json['has_menstrual_disorder'] ?? false,
      hadSurgery: json['had_surgery'] ?? false,
      wentToGym: json['went_to_gym'] ?? false,
      medications: List<String>.from(json['medications'] ?? []),
      emotionalHanger: json['emotional_hanger'] ?? '',
      weightChange: json['weight_change'] ?? '',
      waterIntake: json['water_intake'] ?? '',
      activityLevel: json['activity_level'] ?? '',
      sleep: json['sleep'] ?? '',
    );
  }

  /// 🟢 إلى JSON
  Map<String, dynamic> toJson() => {
    'chronic_diseases': chronicDiseases,
    'family_chronic_diseases': familyChronicDiseases,
    'joint_pain': jointPain,
    'injuries': injuries,
    'home_equipment': homeEquipment,
    'has_menstrual_disorder': hasMenstrualDisorder,
    'had_surgery': hadSurgery,
    'went_to_gym': wentToGym,
    'medications': medications,
    'emotional_hanger': emotionalHanger,
    'weight_change': weightChange,
    'water_intake': waterIntake,
    'activity_level': activityLevel,
    'sleep': sleep,
  };

  /// 🟢 نسخة وهمية (Fake) للاختبار
  factory QuestionnaireAnswers.fake() {
    return QuestionnaireAnswers(
      chronicDiseases: ["ضغط", "سكر"],
      familyChronicDiseases: ["قلب"],
      jointPain: ["ركبة", "ظهر"],
      injuries: ["إصابة كتف"],
      homeEquipment: ["دامبلز", "مات"],
      hasMenstrualDisorder: true,
      hadSurgery: false,
      wentToGym: true,
      medications: ["دواء للسكر"],
      emotionalHanger: "بيأكل لما يزعل",
      weightChange: "زيادة 5 كجم خلال 3 شهور",
      waterIntake: "6 أكواب يوميًا",
      activityLevel: "متوسط",
      sleep: "6 ساعات يوميًا",
    );
  }
}
