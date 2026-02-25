import 'package:diet_picnic_client/components/custom_snack_bar.dart';
import 'package:diet_picnic_client/core/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:diet_picnic_client/components/custom_snack_bar.dart';
import 'package:diet_picnic_client/core/notification_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class WaterReminderController extends GetxController {
  static WaterReminderController get to => Get.find();

  final GetStorage _storage = GetStorage();

  // Storage keys
  static const String _isEnabledKey = 'water_reminders_enabled';
  static const String _remindersKey = 'water_reminders_data';

  // Observable variables
  final isEnabled = false.obs;
  final isLoading = false.obs;
  final areNotificationsEnabled = false.obs;
  final isCheckingPermission = false.obs;

  // Water reminder schedule data
  final List<WaterReminder> reminders = [
    WaterReminder(
      id: 1,
      time: '4:00 ص',
      message: 'اشرب ماء قبل الفجر في السحور 💧',
      hour: 4,
      minute: 0,
      reason: 'آخر فرصة للترطيب قبل بداية الصيام، اشرب كمية كويسة',
    ),
    WaterReminder(
      id: 2,
      time: '5:00 ص',
      message: 'كوب ماء أخير قبل الإمساك 🌙',
      hour: 5,
      minute: 0,
      reason: 'آخر فرصة لشرب الماء قبل أذان الفجر والإمساك',
    ),
    WaterReminder(
      id: 3,
      time: '6:00 م',
      message: 'حان وقت الإفطار! ابدأ بماء وتمر 🌴',
      hour: 18,
      minute: 0,
      reason: 'أفضل طريقة لكسر الصيام هي الماء والتمر زي السنة النبوية',
    ),
    WaterReminder(
      id: 4,
      time: '7:00 م',
      message: 'اشرب كوب ماء بعد صلاة المغرب 🕌',
      hour: 19,
      minute: 0,
      reason: 'بعد الصلاة، جسمك محتاج يعوض السوائل اللي فقدها',
    ),
    WaterReminder(
      id: 5,
      time: '8:00 م',
      message: 'كوب ماء قبل التراويح 🌙',
      hour: 20,
      minute: 0,
      reason: 'عشان تكون نشيط في صلاة التراويح',
    ),
    WaterReminder(
      id: 6,
      time: '9:00 م',
      message: 'اشرب ماء بعد التراويح 💧',
      hour: 21,
      minute: 0,
      reason: 'عوض السوائل بعد الوقوف في الصلاة',
    ),
    WaterReminder(
      id: 7,
      time: '10:00 م',
      message: 'ترطيب قبل النوم 😴',
      hour: 22,
      minute: 0,
      reason: 'اشرب كمية معقولة عشان جسمك يبقى رطب أثناء النوم',
    ),
    WaterReminder(
      id: 8,
      time: '11:00 م',
      message: 'كوب ماء أخير قبل النوم 🌙',
      hour: 23,
      minute: 0,
      reason: 'آخر ترطيب قبل النوم عشان تصحى نشيط للسحور',
    ),
    WaterReminder(
      id: 9,
      time: '12:00 ص',
      message: 'لو صاحي، اشرب كوب ماء 💧',
      hour: 0,
      minute: 0,
      reason: 'لو لسه صاحي، فرصة ترطب جسمك قبل السحور',
    ),
  ];
  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    _checkNotificationStatus();
  }

  /// Load saved settings from storage
  void _loadSettings() {
    isEnabled.value = _storage.read(_isEnabledKey) ?? false;

    // Load individual reminder settings if they exist
    final savedReminders = _storage.read(_remindersKey);
    if (savedReminders != null && savedReminders is List) {
      for (var reminderData in savedReminders) {
        final reminder = WaterReminder.fromJson(reminderData);
        final index = reminders.indexWhere((r) => r.id == reminder.id);
        if (index != -1) {
          reminders[index] = reminder;
        }
      }
    }
  }

  /// Save settings to storage
  void _saveSettings() {
    _storage.write(_isEnabledKey, isEnabled.value);
    _storage.write(_remindersKey, reminders.map((r) => r.toJson()).toList());
  }

  /// Check if notifications are enabled on the device
  Future<void> _checkNotificationStatus() async {
    areNotificationsEnabled.value = await NotificationService.areNotificationsEnabled();
  }

  /// Request notification permission from user
  Future<bool> _requestNotificationPermission() async {
    isCheckingPermission.value = true;

    try {
      final permissionGranted = await NotificationService.requestPermission();
      areNotificationsEnabled.value = permissionGranted;

      if (!permissionGranted) {
        showCustomSnackbar(
          title: 'الإذن مرفوض',
          message: 'لن تتلقى تذكيرات شرب الماء بدون السماح بالإشعارات',
          successful: false,
        );
      }

      return permissionGranted;
    } catch (e) {
      showCustomSnackbar(
        title: 'خطأ',
        message: 'حدث خطأ أثناء طلب الإذن: $e',
        successful: false,
      );
      return false;
    } finally {
      isCheckingPermission.value = false;
    }
  }

  /// Check and handle notification permissions
  Future<bool> _ensureNotificationPermission() async {
    // First check if already enabled
    await _checkNotificationStatus();

    if (areNotificationsEnabled.value) {
      return true;
    }

    // Request permission
    final granted = await _requestNotificationPermission();

    if (!granted) {
      // Show dialog to open settings
      final shouldOpenSettings = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('الإشعارات معطلة'),
          content: const Text(
            'لتفعيل تذكيرات شرب الماء، يجب السماح بالإشعارات.\n\nهل تريد فتح إعدادات التطبيق؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              child: const Text('فتح الإعدادات'),
            ),
          ],
        ),
      );

      if (shouldOpenSettings == true) {
        await openNotificationSettings();
      }

      return false;
    }

    return true;
  }

  /// Toggle water reminders on/off
  Future<void> toggleReminders(bool enabled) async {
    isLoading.value = true;

    try {
      if (enabled) {
        // Ensure notification permission is granted
        final hasPermission = await _ensureNotificationPermission();

        if (!hasPermission) {
          isLoading.value = false;
          return;
        }

        // Schedule all enabled reminders
        await _scheduleAllReminders();
        showCustomSnackbar(
          title: 'تم التفعيل',
          message: 'تم تفعيل تذكيرات شرب الماء',
          successful: true,
        );
      } else {
        // Cancel all reminders
        await NotificationService.cancelAllWaterReminders();
        showCustomSnackbar(
          title: 'تم الإيقاف',
          message: 'تم إيقاف تذكيرات شرب الماء',
          successful: true,
        );
      }

      isEnabled.value = enabled;
      _saveSettings();
    } catch (e) {
      showCustomSnackbar(
        title: 'خطأ',
        message: 'حدث خطأ أثناء تحديث الإعدادات: $e',
        successful: false,
      );
    } finally {
      isLoading.value = false;
    }
    update();
  }

  /// Toggle individual reminder
  Future<void> toggleIndividualReminder(int reminderId, bool enabled) async {
    try {
      final reminderIndex = reminders.indexWhere((r) => r.id == reminderId);
      if (reminderIndex == -1) return;

      if (enabled && isEnabled.value) {
        // Check permission before enabling individual reminder
        final hasPermission = await _ensureNotificationPermission();
        if (!hasPermission) {
          return;
        }
      }

      reminders[reminderIndex].isEnabled = enabled;

      if (enabled && isEnabled.value) {
        // Schedule this specific reminder
        await NotificationService.scheduleWaterReminder(
          id: reminderId,
          title: 'تذكير شرب الماء 💧',
          body: reminders[reminderIndex].message,
          hour: reminders[reminderIndex].hour,
          minute: reminders[reminderIndex].minute,
          payload: 'water_reminder_$reminderId',
        );
      } else {
        // Cancel this specific reminder
        await NotificationService.cancelNotification(reminderId);
      }

      _saveSettings();
    } catch (e) {
      showCustomSnackbar(
        title: 'خطأ',
        message: 'حدث خطأ أثناء تحديث التذكير: $e',
        successful: false,
      );
    } finally {
      update();
    }
  }

  /// Schedule all enabled reminders
  Future<void> _scheduleAllReminders() async {
    for (final reminder in reminders) {
      if (reminder.isEnabled) {
        await NotificationService.scheduleWaterReminder(
          id: reminder.id,
          title: 'تذكير شرب الماء 💧',
          body: reminder.message,
          hour: reminder.hour,
          minute: reminder.minute,
          payload: 'water_reminder_${reminder.id}',
        );
      }
    }
    update();
  }

  /// Enable all reminders
  Future<void> enableAllReminders() async {
    // Check permission first
    if (isEnabled.value) {
      final hasPermission = await _ensureNotificationPermission();
      if (!hasPermission) {
        return;
      }
    }

    for (int i = 0; i < reminders.length; i++) {
      reminders[i].isEnabled = true;
    }

    if (isEnabled.value) {
      await _scheduleAllReminders();
    }

    _saveSettings();
    update();
  }

  /// Disable all reminders
  Future<void> disableAllReminders() async {
    for (int i = 0; i < reminders.length; i++) {
      reminders[i].isEnabled = false;
    }

    await NotificationService.cancelAllWaterReminders();
    _saveSettings();
    update();
  }

  /// Open notification settings
  Future<void> openNotificationSettings() async {
    await NotificationService.openNotificationSettings();
    // Re-check permission after user returns from settings
    Future.delayed(const Duration(seconds: 1), () {
      _checkNotificationStatus();
    });
  }

  /// Get pending notifications count
  Future<int> getPendingNotificationsCount() async {
    final pending = await NotificationService.getPendingNotifications();
    return pending.length;
  }

  /// Refresh notification status
  Future<void> refreshNotificationStatus() async {
    await _checkNotificationStatus();
    update();
  }

  /// Handle app resume - check if permissions changed
  Future<void> onAppResume() async {
    await _checkNotificationStatus();

    // If reminders were enabled but permission is now revoked
    if (isEnabled.value && !areNotificationsEnabled.value) {
      showCustomSnackbar(
        title: 'تنبيه',
        message: 'الإشعارات معطلة. لن تتلقى تذكيرات شرب الماء',
        successful: false,
      );
    }
  }
}

/// Water reminder model
class WaterReminder {
  final int id;
  final String time;
  final String message;
  final int hour;
  final int minute;
  final String reason;
  bool isEnabled;

  WaterReminder({
    required this.id,
    required this.time,
    required this.message,
    required this.hour,
    required this.minute,
    required this.reason,
    this.isEnabled = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time,
      'message': message,
      'hour': hour,
      'minute': minute,
      'reason': reason,
      'isEnabled': isEnabled,
    };
  }

  factory WaterReminder.fromJson(Map<String, dynamic> json) {
    return WaterReminder(
      id: json['id'],
      time: json['time'],
      message: json['message'],
      hour: json['hour'],
      minute: json['minute'],
      reason: json['reason'],
      isEnabled: json['isEnabled'] ?? false,
    );
  }
}
