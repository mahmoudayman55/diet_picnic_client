class WeekProgressModel {
  final String id; // Add this field
  final String clientId;
  final double weight;
  final double pelvis;
  final double rightArm;
  final double waist;
  final String? notes;
  final String excuse;
  final DateTime date;
  final DateTime? sentAt;

  WeekProgressModel({
    required this.id, // Now required
    required this.clientId,
    required this.weight,
    required this.pelvis,
    required this.excuse,
    required this.rightArm,
    required this.waist,
    required this.date,
    required this.sentAt,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
        'id': id, // Include the ID
        'client_id': clientId,
        'weight': weight,
        'pelvis': pelvis,
        'right_arm': rightArm,
        'waist': waist,
        'excuse': excuse,
        'notes': notes,
        'sentAt': sentAt?.toIso8601String(),
        'date': date.toIso8601String(),
      };

  factory WeekProgressModel.fromJson(Map<String, dynamic> json) {
    return WeekProgressModel(
      id: json['id'] ?? '',
      // Read from JSON
      clientId: json['client_id'] ?? '',
      weight: (json['weight'] as num).toDouble(),
      pelvis: (json['pelvis'] as num).toDouble(),
      rightArm: (json['right_arm'] as num).toDouble(),
      waist: (json['waist'] as num).toDouble(),
      notes: json['notes'],
      date: DateTime.parse(json['date']),
      excuse: json['excuse'] ?? "",
      sentAt: json['sentAt'] == null ? null : DateTime.parse(json['sentAt']),
    );
  }

  WeekProgressModel copyWith({
    String? id,
    String? clientId,
    String? excuse,
    double? weight,
    double? pelvis,
    double? rightArm,
    double? waist,
    String? notes,
    DateTime? sentAt,
    DateTime? date,
  }) {
    return WeekProgressModel(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      weight: weight ?? this.weight,
      excuse: excuse ?? this.excuse,
      pelvis: pelvis ?? this.pelvis,
      rightArm: rightArm ?? this.rightArm,
      waist: waist ?? this.waist,
      notes: notes ?? this.notes,
      date: date ?? this.date,
      sentAt: sentAt ?? this.sentAt,
    );
  }
}
