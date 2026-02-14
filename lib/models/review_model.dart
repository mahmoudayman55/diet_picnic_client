class ReviewModel {
  final String id;
  final String name;
  final String profileImage;
  final DateTime date;
  final String comment;
  final double rate;

  ReviewModel({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.date,
    required this.comment,
    required this.rate,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json, String id) {
    return ReviewModel(
      name: json['name'] ?? '',
      id: id,
      profileImage: json['profileImage'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      comment: json['comment'] ?? '',
      rate: (json['rate'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'profileImage': profileImage,
      'date': date.toIso8601String(),
      'comment': comment,
      'rate': rate,
    };
  }
}
