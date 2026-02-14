import 'dart:developer';

class FollowUpMessageModel {
  final String id;
  final String clientId;
  final int weekNumber;
  final String day; // 'Saturday' or 'Wednesday'
   DateTime scheduledDate; // The actual Wed/Sat date of that week
  final DateTime sentAt; // The exact datetime the message was sent
  final String? notes;

  FollowUpMessageModel({
    required this.id,
    required this.clientId,
    required this.weekNumber,
    required this.day,

    required this.sentAt,
    this.notes, required this.scheduledDate,
  });
  DateTime getDateOfWeekdayInCustomWeek(String weekday) {
    final now = DateTime.now();
    final weekdayMap = {
      'Saturday': 0,
      'Sunday': 1,
      'Monday': 2,
      'Tuesday': 3,
      'Wednesday': 4,
      'Thursday': 5,
      'Friday': 6,
    };

    final today = now.weekday % 7; // Saturday = 0, Sunday = 1, ..., Friday = 6
    final target = weekdayMap[weekday];

    if (target == null) {
      throw ArgumentError('Invalid weekday: $weekday');
    }

    // Calculate how many days passed since last Saturday
    final daysSinceSaturday = (now.weekday + 1) % 7; // Saturday=0, Sunday=1, ..., Friday=6
    final currentWeekSaturday = now.subtract(Duration(days: daysSinceSaturday));

    // Add offset to get target weekday
    final targetDate = currentWeekSaturday.add(Duration(days: target));

    return DateTime(targetDate.year, targetDate.month, targetDate.day);
  }

  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'weekNumber': weekNumber,
      'day': day,
      'scheduledDate': scheduledDate!.toIso8601String(),
      'sentAt': sentAt.toIso8601String(),
      'notes': notes,
    };
  }

  factory FollowUpMessageModel.fromJson(Map<String, dynamic> json) {

    log(json['scheduledDate'].toString(),name: "FROMJ");
    return FollowUpMessageModel(
      id: json['id'],
      clientId: json['clientId'],
      weekNumber: json['weekNumber'],
      day: json['day'],
      scheduledDate: DateTime.parse(json['scheduledDate']??""),
      sentAt: DateTime.parse(json['sentAt']),
      notes: json['notes'],
    );
  }
}
