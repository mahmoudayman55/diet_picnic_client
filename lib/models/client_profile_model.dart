import 'dart:ui';

import 'package:diet_picnic_client/models/diet_system_model.dart';
import 'package:diet_picnic_client/models/exercise_model.dart';
import 'package:diet_picnic_client/models/exercise_system_model.dart';
import 'package:diet_picnic_client/models/follow_up_message_model.dart';
import 'package:diet_picnic_client/models/package.dart';
import 'package:diet_picnic_client/models/questionnaire_answers.dart';
import 'package:diet_picnic_client/models/week_progress_model.dart';
import 'package:diet_picnic_client/view/weekly_progress_chart_view.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package_model.dart';

final _uuid = Uuid();


class AssignedDietSystem {
  final String id;
  final DateTime assignedAt;
  final String url;
  final bool isActive;
  final String category;

  AssignedDietSystem({
    required this.id,
    required this.assignedAt,
    required this.url,
    required this.isActive,
    required this.category,
  });

  factory AssignedDietSystem.fromJson(Map<String, dynamic> json) {
    return AssignedDietSystem(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      isActive: json['is_active'] ?? false,
      assignedAt: DateTime.parse(json['assigned_at']),
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'url': url,
    'category': category,
    'is_active': isActive,
    'assigned_at': assignedAt.toIso8601String(),
  };

  /// CopyWith method
  AssignedDietSystem copyWith({
    String? id,
    DateTime? assignedAt,
    String? url,
    bool? isActive,
    String? category,
  }) {
    return AssignedDietSystem(
      id: id ?? this.id,
      assignedAt: assignedAt ?? this.assignedAt,
      url: url ?? this.url,
      isActive: isActive ?? this.isActive,
      category: category ?? this.category,
    );
  }

  /// 🟢 Fake data generator
  static AssignedDietSystem fake() => AssignedDietSystem(
    id: _uuid.v4(),
    assignedAt: DateTime.now(),
    url: "https://example.com/diet.pdf",
    category: "Weight Loss",
    isActive: false,
  );
}
class AssignedExerciseSystem {
  final String id;
  final DateTime assignedAt;
  final bool isActive;

  AssignedExerciseSystem({
    required this.id,
    required this.assignedAt,
    required this.isActive,
  });

  factory AssignedExerciseSystem.fromJson(Map<String, dynamic> json) {
    return AssignedExerciseSystem(
      id: json['id'] ?? '',
      assignedAt: DateTime.parse(json['assigned_at']),
      isActive: json['is_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'is_active': isActive,
    'assigned_at': assignedAt.toIso8601String(),
  };

  /// 🔁 copyWith function
  AssignedExerciseSystem copyWith({
    String? id,
    DateTime? assignedAt,
    bool? isActive,
  }) {
    return AssignedExerciseSystem(
      id: id ?? this.id,
      assignedAt: assignedAt ?? this.assignedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  /// 🟢 Fake data generator
  static AssignedExerciseSystem fake() => AssignedExerciseSystem(
    id: _uuid.v4(),
    assignedAt: DateTime.now().subtract(const Duration(days: 3)),
    isActive: false,
  );
}

class ClientProfileModel {
  final String id;
  final String name;
  final String? image;
  final String phone;
  final String password; // 🔑 Hashed password

  // Optional fields
  final String? order;
  final String? address;
  final String? job;
  final String? qualification;
  final String? email;
  final String? height;
  final DateTime? renewalDate;
  final DateTime? birthDate;
  final String? level;
  final String? category;
  String? gender;
  final String? socialStatus;
  bool isLactating;
  bool isPregnant;
  late QuestionnaireAnswers? questionnaireAnswers;
  final Package? package;
  final PackageGroup? group;
  final List<WeekProgressModel> weekProgressList;
  DietSystemModel? dietSystemModel;
  ExerciseSystemModel? exerciseSystemModel;

  // Extended profile
  final List<AssignedDietSystem> assignedDietSystems;
  final List<FollowUpMessageModel> followUps;
  final List<AssignedExerciseSystem> assignedExerciseSystems;
  final DateTime? subscriptionDate;
  final DateTime? startDate;
  final PackageGroup? packageGroup;
  final DateTime? createdAt;

  ClientProfileModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.password,
     this.createdAt,
    this.image,
    this.exerciseSystemModel,
    this.dietSystemModel,
    this.order,
    this.address,
    this.job,
    this.qualification,
    this.email,
    this.height,
    this.renewalDate,
    this.birthDate,
    this.level,
    this.category,
    this.gender,
    this.socialStatus,
    this.isLactating = false,
    this.isPregnant = false,
    this.questionnaireAnswers,
    this.package,
    this.group,
    this.weekProgressList = const [],
    this.assignedDietSystems = const [],
    this.followUps = const [],
    this.assignedExerciseSystems = const [],
    this.subscriptionDate,
    this.startDate,
    this.packageGroup,
  });

  /// Minimal factory for registration
  factory ClientProfileModel.register({
    required String id,
    required String name,
    required String phone,
    required String password,
    required DateTime createdAt,

  }) {
    return ClientProfileModel(
      id: id,
      name: name,
      phone: phone,
      createdAt: createdAt,
      password: password,
    );
  }

  WeekProgressModel getLastFollowing(){
    List<WeekProgressModel>filtered=weekProgressList.where((p){return p.excuse.isEmpty;}).toList();
    filtered.sort((a, b) => a.date.compareTo(b.date));
     return filtered.last;

  }
  WeekProgressModel getFirstFollowing(){
    List<WeekProgressModel>filtered=weekProgressList.where((p){return p.excuse.isEmpty;}).toList();
  filtered.sort((a, b) => a.date.compareTo(b.date));
     return filtered.first;

  }
  bool hasActiveDiet() {
    return assignedDietSystems.any((e) => e.isActive );
  }

  bool hasActiveExercise() {
    return assignedExerciseSystems.any((e) => e.isActive );
  }
  /// From JSON
  factory ClientProfileModel.fromJson(Map<String, dynamic> json, String id) {
    return ClientProfileModel(
      id: id,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      image: json['image'],
      password: json['password'] ?? '',
      order: json['order'],
      qualification: json['qualification'],
      renewalDate: json['renewal_date'] != null
          ? DateTime.tryParse(json['renewal_date'])
          : null,
      createdAt:json['created_at']==null?null: DateTime.tryParse(json['created_at']),

    // renewalDate: DateTime(2025,12,5),
      level: json['level'],
      package:
          json['package'] == null ? null : Package.fromJson(json['package']),
      group:
          json['group'] != null ? PackageGroup.fromJson(json['group']) : null,
      category: json['category'],
      address: json['address'],
      job: json['job'],
      email: json['email'],
      height: json['height'],
      birthDate: json['birth_date'] != null
          ? DateTime.tryParse(json['birth_date'])
          : null,
      gender: json['gender'] ?? "",
      socialStatus: json['social_status'],
      isLactating: json['is_lactating'] ?? false,
      isPregnant: json['is_pregnant'] ?? false,
      questionnaireAnswers: json['questionnaire_answers'] != null
          ? QuestionnaireAnswers.fromJson(json['questionnaire_answers'])
          : null,
      weekProgressList: (json['week_progress'] as List<dynamic>? ?? [])
          .map((e) => WeekProgressModel.fromJson(e))
          .toList(),
      assignedDietSystems:
          (json['assigned_diet_systems'] as List<dynamic>? ?? [])
              .map((e) => AssignedDietSystem.fromJson(e))
              .toList(),
      followUps: (json['follow_ups'] as List<dynamic>? ?? [])
          .map((e) => FollowUpMessageModel.fromJson(e))
          .toList(),
      assignedExerciseSystems:
          (json['assigned_exercise_systems'] as List<dynamic>? ?? [])
              .map((e) => AssignedExerciseSystem.fromJson(e))
              .toList(),
      subscriptionDate: json['subscription_date'] != null
          ? DateTime.tryParse(json['subscription_date'])
          : null,
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'])
          : null,
      packageGroup: json['package_group'] != null
          ? PackageGroup.fromJson(json['package_group'])
          : null,
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'password': password,
        'order': order,
        'image': image,
        'qualification': qualification,
        'renewal_date': renewalDate?.toIso8601String(),
    'created_at': createdAt?.toIso8601String(),
        'level': level,
        if (package != null) 'package': package!.toJson(),
        if (package != null) 'package_id': package!.id,
        'group': group?.toJson(),
        'category': category,
        'address': address,
        'job': job,
        'email': email,
        'height': height,
        'birth_date': birthDate?.toIso8601String(),
        'gender': gender,
        'social_status': socialStatus,
        'is_lactating': isLactating,
        'is_pregnant': isPregnant,
        'questionnaire_answers': questionnaireAnswers?.toJson(),
        'week_progress': weekProgressList.map((e) => e.toJson()).toList(),
        'assigned_diet_systems':
            assignedDietSystems.map((e) => e.toJson()).toList(),
        'follow_ups': followUps.map((e) => e.toJson()).toList(),
        'assigned_exercise_systems':
            assignedExerciseSystems.map((e) => e.toJson()).toList(),
        'subscription_date': subscriptionDate?.toIso8601String(),
        'start_date': startDate?.toIso8601String(),
        'package_group': packageGroup?.toJson(),
      };

  // /// Fake data
  // factory ClientProfileModel.fake() {
  //   final package = Package.fake();
  //   return ClientProfileModel(
  //     id: _uuid.v4(),
  //     name: "John Doe",
  //     phone: "0123456789",
  //     password: "hashedPassword123",
  //     order: "001",
  //     qualification: "Bachelor",
  //     renewalDate: DateTime.now().add(const Duration(days: 30)),
  //     level: "VIP",
  //     package: package,
  //     group: PackageGroup.dummyList("pkg1")[0],
  //     category: "Diet",
  //     address: "123 Cairo St.",
  //     job: "Engineer",
  //     email: "john.doe@example.com",
  //     height: "175",
  //     birthDate: DateTime(1995, 5, 20),
  //     gender: "Male",
  //     socialStatus: "Single",
  //     isLactating: false,
  //     isPregnant: false,
  //     questionnaireAnswers: QuestionnaireAnswers.fake(),
  //     weekProgressList: [WeekProgressModel.fake()],
  //     assignedDietSystems: [AssignedDietSystem.fake()],
  //     assignedExerciseSystems: [AssignedExerciseSystem.fake()],
  //     followUps: [],
  //     subscriptionDate: DateTime.now().subtract(const Duration(days: 10)),
  //     startDate: DateTime.now().subtract(const Duration(days: 5)),
  //     packageGroup: PackageGroup.dummyList("pkg1").first,
  //   );
  // }

  // /// Fake list
  // static List<ClientProfileModel> fakeList() {
  //   return List.generate(5, (i) => ClientProfileModel.fake().copyWith(id: "c$i"));
  // }

  /// Helpers
  String get timeLeft {
    if (renewalDate == null) return 'غير محدد';
    final now = DateTime.now();
    final diff = renewalDate!.difference(now);
    if (diff.inDays < 0) return 'منتهي';

    int days = diff.inDays;
    final months = days ~/ 30;
    days %= 30;
    final weeks = days ~/ 7;
    days %= 7;

    final parts = <String>[];
    if (months > 0) parts.add('$months ش');
    if (weeks > 0) parts.add('$weeks أ');
    if (days > 0) parts.add('$days ي');
    return parts.isEmpty ? 'اليوم' : parts.join(' و ');
  }

  Color get timeLeftColor {
    if (renewalDate == null) return Colors.grey;
    final diff = renewalDate!.difference(DateTime.now());
    if (diff.inDays < 0) return Colors.black;
    if (diff.inDays <= 14) return Colors.red;
    if (diff.inDays <= 30) return Colors.orange;
    return Colors.green;
  }

  bool get isExpired => renewalDate?.isBefore(DateTime.now()) ?? false;

  int get age => birthDate != null ? DateTime.now().year - birthDate!.year : 0;

  bool get weeklyFollowUpSent {
    if (weekProgressList.isEmpty) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Find the most recent Friday that has passed (not including today if today is Friday)
    int daysToSubtract;

    if (now.weekday == DateTime.friday) {
      daysToSubtract = 0; // Today is Friday, start of current week
    } else if (now.weekday == DateTime.saturday) {
      daysToSubtract = 1; // Yesterday was Friday
    } else if (now.weekday == DateTime.sunday) {
      daysToSubtract = 2; // Friday was 2 days ago
    } else {
      // Monday(1) to Thursday(4)
      daysToSubtract = now.weekday + 2; // Mon:3, Tue:4, Wed:5, Thu:6
    }

    final weekStart = today.subtract(Duration(days: daysToSubtract));
    final weekEnd = weekStart.add(const Duration(days: 7));

    return weekProgressList.any((wp) {
      final date = DateTime(wp.date.year, wp.date.month, wp.date.day);
      return !date.isBefore(weekStart) && date.isBefore(weekEnd);
    });
  }


  /// CopyWith
  ClientProfileModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? password,
    String? order,
    String? qualification,
    String? job,
    String? address,
    String? email,
    String? height,
    DateTime? renewalDate,
    String? level,
    Package? package,
    String? category,
    DateTime? birthDate,
    String? gender,
    String? socialStatus,
    bool? isLactating,
    bool? isPregnant,
    QuestionnaireAnswers? questionnaireAnswers,
    List<WeekProgressModel>? weekProgressList,
    PackageGroup? group,
    DietSystemModel? dietSystemModel,
    ExerciseSystemModel? exerciseSystemModel,
    List<AssignedDietSystem>? assignedDietSystems,
    List<FollowUpMessageModel>? followUps,
    List<AssignedExerciseSystem>? assignedExerciseSystems,
    DateTime? subscriptionDate,
    DateTime? startDate,
    PackageGroup? packageGroup,
    String? image,
    DateTime? createdAt,

  }) {
    return ClientProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      order: order ?? this.order,
      qualification: qualification ?? this.qualification,
      job: job ?? this.job,
      address: address ?? this.address,
      email: email ?? this.email,
      height: height ?? this.height,
      renewalDate: renewalDate ?? this.renewalDate,
      level: level ?? this.level,
      image: image ?? this.image,
      package: package??this.package,
      exerciseSystemModel: exerciseSystemModel,
      dietSystemModel: dietSystemModel,
      category: category ?? this.category,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      socialStatus: socialStatus ?? this.socialStatus,
      isLactating: isLactating ?? this.isLactating,
      isPregnant: isPregnant ?? this.isPregnant,
      questionnaireAnswers: questionnaireAnswers ?? this.questionnaireAnswers,
      weekProgressList: weekProgressList ?? this.weekProgressList,
      group: group ?? this.group,
      assignedDietSystems: assignedDietSystems ?? this.assignedDietSystems,
      followUps: followUps ?? this.followUps,
      assignedExerciseSystems:
          assignedExerciseSystems ?? this.assignedExerciseSystems,
      subscriptionDate: subscriptionDate ?? this.subscriptionDate,
      startDate: startDate ?? this.startDate,
      packageGroup: packageGroup ?? this.packageGroup,
      createdAt: createdAt ?? this.createdAt,

    );
  }
}
