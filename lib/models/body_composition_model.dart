import 'dart:developer';

class BodyCompositionModel {
  final String gender;
  final double height; // in cm
  final double weight; // in kg
  final double waistCircumference; // in cm
  final double hipCircumference; // in cm

  BodyCompositionModel({
    required this.gender,
    required this.height,
    required this.weight,
    required this.waistCircumference,
    required this.hipCircumference,
  });

  // Calculate Ideal Body Weight (IBW)
  double get idealBodyWeight => height - 100;

  // Calculate BMI
  double get bmi => weight / ((height / 100) * (height / 100));

  // Calculate Waist-to-Hip Ratio (WHR)
  double get waistToHipRatio => waistCircumference / hipCircumference;

  // Check Central Obesity
  bool get hasCentralObesity {
    if (gender.toLowerCase() == 'male') {
      return waistCircumference >= 102;
    } else {
      return waistCircumference >= 88;
    }
  }

  // Get BMI Category
  BMICategory get bmiCategory {
    if (bmi < 18.5) {
      return BMICategory.underweight;
    } else if (bmi >= 18.5 && bmi < 25) {
      return BMICategory.normal;
    } else if (bmi >= 25 && bmi < 30) {
      return BMICategory.overweight;
    } else if (bmi >= 30 && bmi < 35) {
      return BMICategory.obesityGradeI;
    } else if (bmi >= 35 && bmi < 40) {
      return BMICategory.obesityGradeII;
    } else {
      return BMICategory.obesityGradeIII;
    }
  }

  // Get WHR Risk Level
  WHRRiskLevel get whrRiskLevel {
    log(waistToHipRatio.toString());
    if (gender.toLowerCase() == 'ذكر') {
      if (waistToHipRatio < 0.95) {
        return WHRRiskLevel.lowRisk;
      } else if (waistToHipRatio >= 0.95 && waistToHipRatio <= 1.0) {
        return WHRRiskLevel.moderateRisk;
      } else {
        return WHRRiskLevel.highRisk;
      }
    } else {
      if (waistToHipRatio < 0.8) {
        return WHRRiskLevel.lowRisk;
      } else if (waistToHipRatio >= 0.8 && waistToHipRatio <= 0.95) {
        return WHRRiskLevel.moderateRisk;
      } else {
        return WHRRiskLevel.highRisk;
      }
    }
  }

  // Get BMI Category Arabic text
  String get bmiCategoryText {
    switch (bmiCategory) {
      case BMICategory.underweight:
        return 'نقص الوزن';
      case BMICategory.normal:
        return 'وزن طبيعي';
      case BMICategory.overweight:
        return 'زيادة في الوزن';
      case BMICategory.obesityGradeI:
        return 'سمنة درجة أولى';
      case BMICategory.obesityGradeII:
        return 'سمنة درجة ثانية';
      case BMICategory.obesityGradeIII:
        return 'سمنة درجة ثالثة';
    }
  }

  // Get WHR Risk Level Arabic text
  String get whrRiskLevelText {
    log(whrRiskLevel.toString());
    switch (whrRiskLevel) {
      case WHRRiskLevel.lowRisk:
        return 'خطر منخفض (الإصابة بالأمراض المزمنة)';
      case WHRRiskLevel.moderateRisk:
        return 'خطر متوسط (الإصابة بالأمراض المزمنة)';
      case WHRRiskLevel.highRisk:
        return 'خطر عالي (الإصابة بالأمراض المزمنة)';
    }
  }

  // Get BMI Category Color
  int get bmiCategoryColor {
    switch (bmiCategory) {
      case BMICategory.underweight:
        return 0xFF2196F3; // Blue
      case BMICategory.normal:
        return 0xFF4CAF50; // Green
      case BMICategory.overweight:
        return 0xFFFF9800; // Orange
      case BMICategory.obesityGradeI:
        return 0xFFFF5722; // Deep Orange
      case BMICategory.obesityGradeII:
        return 0xFFE91E63; // Pink
      case BMICategory.obesityGradeIII:
        return 0xFFF44336; // Red
    }
  }

  // Get WHR Risk Level Color
  int get whrRiskLevelColor {
    switch (whrRiskLevel) {
      case WHRRiskLevel.lowRisk:
        return 0xFF4CAF50; // Green
      case WHRRiskLevel.moderateRisk:
        return 0xFFFF9800; // Orange
      case WHRRiskLevel.highRisk:
        return 0xFFF44336; // Red
    }
  }

  // Validation
  bool get isValid {
    return height > 0 && 
           weight > 0 && 
           waistCircumference > 0 && 
           hipCircumference > 0 &&
           gender.isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'height': height,
      'weight': weight,
      'waistCircumference': waistCircumference,
      'hipCircumference': hipCircumference,
    };
  }

  factory BodyCompositionModel.fromJson(Map<String, dynamic> json) {
    return BodyCompositionModel(
      gender: json['gender'],
      height: json['height'].toDouble(),
      weight: json['weight'].toDouble(),
      waistCircumference: json['waistCircumference'].toDouble(),
      hipCircumference: json['hipCircumference'].toDouble(),
    );
  }
}

enum BMICategory {
  underweight,
  normal,
  overweight,
  obesityGradeI,
  obesityGradeII,
  obesityGradeIII,
}

enum WHRRiskLevel {
  lowRisk,
  moderateRisk,
  highRisk,
}
