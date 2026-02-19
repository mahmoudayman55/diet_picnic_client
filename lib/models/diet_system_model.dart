class DietSystemModel {
  final String id;
  final String name;
  final String category1Link;
  final int order;
  final String category2Link;
  final String category3Link;
  final List<String> instructions;
  final DateTime? assignedAt;

  DietSystemModel({
    required this.id,
    required this.name,
    required this.assignedAt,
    required this.order,
    required this.category1Link,
    required this.category2Link,
    required this.category3Link,
    required this.instructions,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'order': order,
    'category1Link': category1Link,
    'category2Link': category2Link,
    'category3Link': category3Link,
    'instructions': instructions,
  };

  factory DietSystemModel.fromJson(Map<String, dynamic> json,DateTime? assignedAt) {
    return DietSystemModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category1Link: json['category1Link'] ?? '',
      category2Link: json['category2Link'] ?? '',
      category3Link: json['category3Link'] ?? '',
      assignedAt: assignedAt ,
      instructions: List<String>.from(json['instructions'] ?? []), order: json['order'],
    );
  }
}
