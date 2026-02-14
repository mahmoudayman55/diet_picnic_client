import 'package:diet_picnic_client/core/notification_service.dart';
import 'package:flutter/foundation.dart';

class NotificationTestHelper {
  /// Test immediate notification (for testing purposes)
  static Future<void> testImmediateNotification() async {
    try {
      await NotificationService.scheduleWaterReminder(
        id: 999, // Use a test ID
        title: '🧪 Test Notification',
        body: 'This is a test notification to verify the system is working!',
        hour: DateTime.now().hour,
        minute: DateTime.now().minute + 2, // Schedule 1 minute from now
        payload: 'test_notification',
      );
      
      if (kDebugMode) {
        print('✅ Test notification scheduled for 1 minute from now');
        print('📱 Check your device for the notification');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error scheduling test notification: $e');
      }
    }
  }

  /// Test notification with custom time (for testing purposes)
  static Future<void> testScheduledNotification({
    required int hoursFromNow,
    required int minutesFromNow,
  }) async {
    try {
      final now = DateTime.now();
      final testTime = now.add(Duration(hours: hoursFromNow, minutes: minutesFromNow));
      
      await NotificationService.scheduleWaterReminder(
        id: 998, // Use a different test ID
        title: '🧪 Scheduled Test',
        body: 'This notification was scheduled for testing!',
        hour: testTime.hour,
        minute: testTime.minute,
        payload: 'scheduled_test_notification',
      );
      
      if (kDebugMode) {
        print('✅ Test notification scheduled for ${testTime.toString()}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error scheduling test notification: $e');
      }
    }
  }

  /// Check notification permissions and status
  static Future<void> checkNotificationStatus() async {
    try {
      final areEnabled = await NotificationService.areNotificationsEnabled();
      final pending = await NotificationService.getPendingNotifications();
      
      if (kDebugMode) {
        print('📊 Notification Status Report:');
        print('   Notifications Enabled: ${areEnabled ? "✅ Yes" : "❌ No"}');
        print('   Pending Notifications: ${pending.length}');
        
        if (pending.isNotEmpty) {
          print('   📋 Pending Notification Details:');
          for (var notification in pending) {
            print('      - ID: ${notification.id}');
            print('        Title: ${notification.title}');
            print('        Body: ${notification.body}');
            print('        Payload: ${notification.payload}');
            print('        ---');
          }
        } else {
          print('   ⚠️ No pending notifications found!');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error checking notification status: $e');
      }
    }
  }

  /// Cancel all test notifications
  static Future<void> cancelTestNotifications() async {
    try {
      await NotificationService.cancelNotification(999);
      await NotificationService.cancelNotification(998);
      
      if (kDebugMode) {
        print('🧹 Test notifications cancelled');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error cancelling test notifications: $e');
      }
    }
  }

  /// Verify daily repetition is enabled for water reminders
  static Future<void> verifyDailyRepetition() async {
    try {
      final pending = await NotificationService.getPendingNotifications();
      
      if (kDebugMode) {
        print('🔄 Daily Repetition Verification:');
        print('   Total pending notifications: ${pending.length}');
        
        // Filter water reminders (IDs 1-6)
        final waterReminders = pending.where((n) => n.id >= 1 && n.id <= 6).toList();
        print('   Water reminders scheduled: ${waterReminders.length}');
        
        if (waterReminders.isNotEmpty) {
          print('   ✅ Water reminders will repeat DAILY at their scheduled times');
          for (var reminder in waterReminders) {
            print('      - Reminder ID ${reminder.id}: ${reminder.title}');
          }
        } else {
          print('   ⚠️ No water reminders are currently scheduled');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error verifying daily repetition: $e');
      }
    }
  }

  /// Test all water reminders (schedules them for testing)
  static Future<void> testAllWaterReminders() async {
    final testReminders = [
      {'id': 1, 'hour': DateTime.now().hour, 'minute': DateTime.now().minute + 2, 'message': 'Test: ابدأ يومك بكوب ماء 🥤'},
      {'id': 2, 'hour': DateTime.now().hour, 'minute': DateTime.now().minute + 4, 'message': 'Test: وقت لترطيب الجسم قبل منتصف اليوم 💧'},
      {'id': 3, 'hour': DateTime.now().hour, 'minute': DateTime.now().minute + 6, 'message': 'Test: اشرب كوب ماء قبل الغداء 🍽️'},
    ];

    for (var reminder in testReminders) {
      try {
        await NotificationService.scheduleWaterReminder(
          id: reminder['id'] as int,
          title: '🧪 Test Water Reminder',
          body: reminder['message'] as String,
          hour: reminder['hour'] as int,
          minute: reminder['minute'] as int,
          payload: 'test_water_reminder_${reminder['id']}',
        );
      } catch (e) {
        if (kDebugMode) {
          print('❌ Error scheduling reminder ${reminder['id']}: $e');
        }
      }
    }

    if (kDebugMode) {
      print('🧪 Test water reminders scheduled:');
      print('   - 2 minutes from now');
      print('   - 4 minutes from now');
      print('   - 6 minutes from now');
    }
  }
}
