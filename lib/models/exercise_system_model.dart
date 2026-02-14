import 'exercise_model.dart';

class ExerciseSystemModel {
  final String id;
  final String name;
  final String instructions;
  final List<ExerciseModel> exercises;

  ExerciseSystemModel({
    required this.id,
    required this.name,
    required this.instructions,
    required this.exercises,
  });

  factory ExerciseSystemModel.fromJson(Map<String, dynamic> json, String id) => ExerciseSystemModel(
        id: id,
        name: json['name'] ?? '',
        instructions: json['instructions'] ?? '',
        exercises: (json['exercises'] as List<dynamic>? ?? [])
            .map((e) => ExerciseModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'instructions': instructions,
        'exercises': exercises.map((e) => e.toJson()).toList(),
      };

  ExerciseSystemModel copyWith({
    String? id,
    String? name,
    String? instructions,
    String? category,
    List<ExerciseModel>? exercises,
  }) {
    return ExerciseSystemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      instructions: instructions ?? this.instructions,
      exercises: exercises ?? this.exercises,
    );
  }
} 