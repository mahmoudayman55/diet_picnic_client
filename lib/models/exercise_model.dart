class ExerciseModel {
  final String name;
  final String url;

  ExerciseModel({required this.name, required this.url});

  factory ExerciseModel.fromJson(Map<String, dynamic> json) => ExerciseModel(
        name: json['name'] ?? '',
        url: json['url'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'url': url,
      };
} 
