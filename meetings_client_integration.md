# Meetings Feature – Client App Integration Guide (v2)

## ما الذي تغيّر؟

| # | التغيير |
|---|---------|
| 1 | **إلغاء تحديد الباقة/المستوى/المجموعة** — الاجتماعات ظاهرة لجميع العملاء بدون أي فلترة |
| 2 | الوقت يُخزَّن ويُعرض بصيغة **AM/PM** بدلاً من 24h |
| 3 | زر "انضم" يظهر فقط إذا حان وقت الاجتماع أو مر عليه |

> [!IMPORTANT]
> **لا يوجد packageId أو packageType أو level أو group** في الـ Firestore document ولا في الـ Model.
> جميع العملاء يشوفون جميع الاجتماعات بمجرد وصول `showToClientsDate`.

---

## Firestore Collection: `meetings`

| Field               | Type   | Description |
|---------------------|--------|-------------|
| `title`             | String | عنوان الاجتماع |
| `description`       | String | وصف الاجتماع |
| `joinUrl`           | String | رابط الانضمام |
| `date`              | String | `"YYYY-MM-DD"` |
| `time`              | String | `"h:mm AM/PM"` — مثال: `"2:30 PM"` |
| `showToClientsDate` | String | `"YYYY-MM-DD"` — تاريخ ظهور الاجتماع للعملاء |

---

## 1. صيغة الوقت — AM/PM

### التخزين
الوقت مخزون كـ String بصيغة `"h:mm AM/PM"` مثلاً: `"2:30 PM"`, `"10:00 AM"`.

### التحويل عند العرض
لا حاجة لأي تحويل — اعرض `meeting.time` مباشرة كما هي.

### التحويل عند القراءة للـ TimePicker (عند التعديل)
```dart
TimeOfDay? parseTimeAmPm(String? s) {
  if (s == null || s.isEmpty) return null;

  // AM/PM format: "2:30 PM"
  final match = RegExp(r'(\d+):(\d+)\s*(AM|PM)', caseSensitive: false)
      .firstMatch(s);
  if (match != null) {
    int hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    final period = match.group(3)!.toUpperCase();
    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;
    return TimeOfDay(hour: hour, minute: minute);
  }

  // Fallback: legacy "HH:mm" format
  final parts = s.split(':');
  if (parts.length < 2) return null;
  return TimeOfDay(
    hour: int.tryParse(parts[0]) ?? 0,
    minute: int.tryParse(parts[1]) ?? 0,
  );
}
```

### التحويل من TimeOfDay إلى String AM/PM (بعد اختيار الوقت)
```dart
String formatTimeAmPm(TimeOfDay t) {
  final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
  final minute = t.minute.toString().padLeft(2, '0');
  final period = t.period == DayPeriod.am ? 'AM' : 'PM';
  return '$hour:$minute $period';
}
```

---

## 2. منطق قفل زر "انضم"

### القاعدة
> الزر يكون **مفعّلاً فقط** إذا وصل أو مضى وقت الاجتماع.
> أي: `meetingDateTime <= now`

### الكود

```dart
/// Returns true when the meeting time has arrived or passed
bool isMeetingJoinable(String date, String time) {
  try {
    final meetingDate = DateTime.parse(date); // "YYYY-MM-DD"
    final parsedTime = parseTimeAmPm(time);   // see above
    if (parsedTime == null) return false;

    final meetingDateTime = DateTime(
      meetingDate.year,
      meetingDate.month,
      meetingDate.day,
      parsedTime.hour,
      parsedTime.minute,
    );

    return DateTime.now().isAfter(meetingDateTime) ||
           DateTime.now().isAtSameMomentAs(meetingDateTime);
  } catch (_) {
    return false;
  }
}
```

---

## 3. عرض زر "انضم" في الكارت

```dart
final joinable = isMeetingJoinable(meeting.date, meeting.time);

ElevatedButton(
  onPressed: joinable && meeting.joinUrl.isNotEmpty
      ? () => launchUrl(Uri.parse(meeting.joinUrl),
            mode: LaunchMode.externalApplication)
      : null,  // null = disabled
  style: ElevatedButton.styleFrom(
    backgroundColor: joinable ? Colors.green : Colors.grey,
  ),
  child: Text(joinable ? 'انضم الآن' : 'لم يحن الوقت بعد'),
),
```

---

## 4. منطق الظهور الكامل (مراجعة)

```
showToClientsDate <= today   →  الاجتماع مرئي للعميل
date >= today                →  يظهر في قائمة القادمة / البانر
isMeetingJoinable(...)       →  زر الانضمام مفعّل
```

| الحالة | مرئي؟ | في القادمة؟ | زر انضم؟ |
|--------|--------|------------|---------|
| showToClientsDate في المستقبل | ❌ | ❌ | ❌ |
| showDate وصل، الاجتماع لم يجئ بعد | ✅ | ✅ | ❌ (رمادي) |
| وقت الاجتماع وصل أو مضى | ✅ | ✅ | ✅ (أخضر) |
| الاجتماع انتهى (date في الماضي) | ✅ | ❌ (في السجل) | ✅ لو في نفس اليوم |

---

## 5. فلترة الاجتماعات من Firestore

```dart
Future<List<MeetingModel>> getVisibleMeetings() async {
  final now = DateTime.now();
  final todayStr =
      '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

  final snapshot = await FirebaseFirestore.instance
      .collection('meetings')
      .orderBy('date')
      .get();

  return snapshot.docs
      .map((doc) => MeetingModel.fromJson(doc.data(), doc.id))
      .where((m) => m.showToClientsDate.compareTo(todayStr) <= 0)
      .toList();
}
```

---

## MeetingModel

```dart
class MeetingModel {
  final String id;
  final String title;
  final String description;
  final String joinUrl;
  final String date;              // "YYYY-MM-DD"
  final String time;              // "h:mm AM/PM"
  final String showToClientsDate; // "YYYY-MM-DD"

  MeetingModel({
    required this.id,
    required this.title,
    required this.description,
    required this.joinUrl,
    required this.date,
    required this.time,
    required this.showToClientsDate,
  });

  factory MeetingModel.fromJson(Map<String, dynamic> json, String id) {
    return MeetingModel(
      id: id,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      joinUrl: json['joinUrl'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      showToClientsDate: json['showToClientsDate'] ?? '',
    );
  }
}
```

---

## ملاحظات للـ AI Agent

1. **لا تحتاج Composite Index** — الـ Query هو `orderBy('date')` فقط.
2. **الوقت string مباشر** — `meeting.time` اعرضها مباشرة بدون تحويل.
3. **زر الانضمام** — استخدم `isMeetingJoinable` لتحديد الحالة، مش بس التاريخ.
4. **url_launcher** — تأكد من إضافة `url_launcher` في `pubspec.yaml` و`Info.plist` / `AndroidManifest.xml`.
5. **Refresh** — اعمل refresh للاجتماعات كل مرة يدخل الـ screen علشان تتحدث حالة الزر.
