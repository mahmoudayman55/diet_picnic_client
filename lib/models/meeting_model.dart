class MeetingModel {
  final String id;
  final String title;
  final String description;
  final String joinUrl;
  final String date; // "YYYY-MM-DD"
  final String time; // "HH:mm"

  MeetingModel({
    required this.id,
    required this.title,
    required this.description,
    required this.joinUrl,
    required this.date,
    required this.time,
  });

  factory MeetingModel.fromJson(Map<String, dynamic> json, String id) {
    return MeetingModel(
      id: id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      joinUrl: json['joinUrl'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
    );
  }

  /// Whether the meeting is today or in the future (upcoming)
  bool get isUpcoming {
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return date.compareTo(todayStr) >= 0;
  }

  /// Whether the meeting is in the past
  bool get isPast => !isUpcoming;

  /// Whether the meeting's scheduled time has been reached (can join now)
  bool get hasStarted {
    try {
      return DateTime.now().isAfter(meetingDateTime) ||
          DateTime.now().isAtSameMomentAs(meetingDateTime);
    } catch (_) {
      return false;
    }
  }

  /// Whether the meeting ended — 90 minutes after start time
  bool get hasExpired {
    try {
      return DateTime.now().isAfter(
        meetingDateTime.add(const Duration(minutes: 90)),
      );
    } catch (_) {
      return false;
    }
  }

  DateTime get meetingDateTime {
    final dateParts = date.split('-');
    final year = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final day = int.parse(dateParts[2]);

    int hour;
    int minute;

    final upper = time.trim().toUpperCase();
    if (upper.contains('AM') || upper.contains('PM')) {
      // 12-hour format — e.g. "9:00 PM" or "11:30 AM"
      final isPM = upper.contains('PM');
      final cleaned = upper.replaceAll('AM', '').replaceAll('PM', '').trim();
      final parts = cleaned.split(':');
      hour = int.parse(parts[0]);
      minute = int.parse(parts[1].trim());
      if (isPM && hour != 12) hour += 12;
      if (!isPM && hour == 12) hour = 0;
    } else {
      // 24-hour format — e.g. "21:00" or "09:30"
      final parts = time.split(':');
      hour = int.parse(parts[0]);
      minute = int.parse(parts[1]);
    }

    return DateTime(year, month, day, hour, minute);
  }
}
