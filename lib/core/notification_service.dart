import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  static const String _channelId = 'water_reminder_channel';
  static const String _channelName = 'Water Reminder';
  static const String _channelDescription = 'Reminds you to drink water throughout the day';

  /// Initialize the notification service
  static Future<void> initialize() async {
    try {
      if (kDebugMode) {
        print('🔔 Initializing notification service...');
      }

      // Initialize timezone data
      tz.initializeTimeZones();

      // Android initialization settings
      const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization settings
      const DarwinInitializationSettings iosSettings =
      DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      if (kDebugMode) {
        print('✅ Notification plugin initialized');
      }

      // Create notification channel for Android
      if (Platform.isAndroid) {
        await _createNotificationChannel();
        if (kDebugMode) {
          print('✅ Android notification channel created');
        }
      }

      // Check initial permission status
      if (kDebugMode) {
        final hasPermission = await areNotificationsEnabled();
        print('📱 Initial notification permission status: ${hasPermission ? "✅ Granted" : "❌ Not granted"}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error initializing notification service: $e');
      }
    }
  }

  /// Create notification channel for Android
  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Request notification permission - returns true if granted
  static Future<bool> requestPermission() async {
    try {
      if (Platform.isAndroid) {
        final androidImpl = _notifications
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

        if (androidImpl != null) {
          // Request basic notification permission (Android 13+)
          final notificationGranted = await androidImpl.requestNotificationsPermission() ?? false;

          if (kDebugMode) {
            print('📱 Notification permission: ${notificationGranted ? "✅ Granted" : "❌ Denied"}');
          }

          // Request exact alarm permission (Android 12+ / API 31+)
          final exactAlarmGranted = await androidImpl.requestExactAlarmsPermission() ?? false;

          if (kDebugMode) {
            print('⏰ Exact alarm permission: ${exactAlarmGranted ? "✅ Granted" : "❌ Denied"}');
          }

          // Return true if notification permission is granted
          // Exact alarm permission is optional but recommended
          return notificationGranted;
        }

        return false;

      } else if (Platform.isIOS) {
        final iosImpl = _notifications
            .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

        if (iosImpl != null) {
          final granted = await iosImpl.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

          if (kDebugMode) {
            print('📱 iOS notification permission: ${granted == true ? "✅ Granted" : "❌ Denied"}');
          }

          return granted ?? false;
        }
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error requesting notification permission: $e');
      }
      return false;
    }
  }

  /// Request permissions (deprecated - use requestPermission instead)
  @Deprecated('Use requestPermission() instead')
  static Future<void> requestPermissions() async {
    await requestPermission();
  }

  /// Handle notification tap
  static void _onNotificationTapped(NotificationResponse response) {
    if (kDebugMode) {
      print('Notification tapped: ${response.payload}');
    }
    // You can add navigation logic here based on the payload
  }

  /// Check if notifications are enabled
  static Future<bool> areNotificationsEnabled() async {
    try {
      if (Platform.isAndroid) {
        final androidImpl = _notifications
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

        if (androidImpl == null) return false;

        // Check basic notification permission
        final notificationsEnabled = await androidImpl.areNotificationsEnabled() ?? false;

        if (kDebugMode) {
          print('📱 Notifications enabled: $notificationsEnabled');
        }

        return notificationsEnabled;

      } else if (Platform.isIOS) {
        // For iOS, we assume notifications are enabled after initialization
        // The actual permission check happens during requestPermission
        final iosImpl = _notifications
            .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

        return iosImpl != null;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error checking notification status: $e');
      }
      return false;
    }
  }

  /// Open app notification settings
  static Future<void> openNotificationSettings() async {
    try {
      if (Platform.isAndroid) {
        final androidImpl = _notifications
            .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

        if (androidImpl != null) {
          // This will trigger the permission dialog or open settings
          await androidImpl.requestNotificationsPermission();
        }
      } else if (Platform.isIOS) {
        // For iOS, there's no direct way to open settings
        // The user needs to go to Settings > App manually
        if (kDebugMode) {
          print('⚠️ Please go to Settings > Notifications to enable notifications for this app');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error opening notification settings: $e');
      }
    }
  }

  /// Schedule a water reminder notification
  static Future<void> scheduleWaterReminder({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String? payload,
  }) async {
    try {
      // Verify permissions before scheduling
      final hasPermission = await areNotificationsEnabled();
      if (!hasPermission) {
        if (kDebugMode) {
          print('⚠️ Cannot schedule notification - permissions not granted');
        }
        throw Exception('Notification permissions not granted');
      }

      if (kDebugMode) {
        print('📅 Attempting to schedule notification:');
        print('   ID: $id');
        print('   Title: $title');
        print('   Time: $hour:$minute');
      }

      // Get current timezone
      final now = DateTime.now();

      if (kDebugMode) {
        print('   Current time: $now');
      }

      // Create scheduled time for today
      var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);

      // If the time has already passed today, schedule for tomorrow
      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
        if (kDebugMode) {
          print('   ⏰ Time has passed, scheduling for tomorrow');
        }
      }

      if (kDebugMode) {
        print('   Scheduled time: $scheduledDate');
        print('   Time until notification: ${scheduledDate.difference(now).inMinutes} minutes');
      }

      // Android notification details
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        playSound: true,
        enableVibration: true,
        ongoing: false,
        autoCancel: true,
        channelShowBadge: true,
      );

      // iOS notification details
      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'default',
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      // Schedule the notification
      await _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails,
        payload: payload,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Use exact scheduling
      );

      if (kDebugMode) {
        print('✅ Water reminder scheduled successfully for $scheduledDate: $title');
        print('🔄 Daily repetition: ENABLED (will repeat every day at $hour:$minute)');
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('❌ Error scheduling water reminder: $e');
        print('Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  /// Cancel a specific notification
  static Future<void> cancelNotification(int id) async {
    try {
      await _notifications.cancel(id);
      if (kDebugMode) {
        print('✅ Cancelled notification: $id');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error cancelling notification $id: $e');
      }
    }
  }

  /// Cancel all water reminder notifications
  static Future<void> cancelAllWaterReminders() async {
    try {
      // Cancel all water reminder notifications (IDs 1-6)
      for (int i = 1; i <= 6; i++) {
        await _notifications.cancel(i);
      }

      if (kDebugMode) {
        print('✅ Cancelled all water reminders');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error cancelling water reminders: $e');
      }
    }
  }

  /// Cancel all notifications
  static Future<void> cancelAllNotifications() async {
    try {
      await _notifications.cancelAll();
      if (kDebugMode) {
        print('✅ Cancelled all notifications');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error cancelling all notifications: $e');
      }
    }
  }

  /// Get pending notifications
  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _notifications.pendingNotificationRequests();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting pending notifications: $e');
      }
      return [];
    }
  }

  /// Get count of pending water reminders
  static Future<int> getPendingWaterRemindersCount() async {
    try {
      final pending = await getPendingNotifications();
      // Filter for water reminder IDs (1-6)
      return pending.where((n) => n.id >= 1 && n.id <= 6).length;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting pending water reminders count: $e');
      }
      return 0;
    }
  }

  /// Debug: Print all pending notifications
  static Future<void> debugPrintPendingNotifications() async {
    if (kDebugMode) {
      try {
        final pending = await getPendingNotifications();
        print('📋 Pending Notifications Count: ${pending.length}');

        if (pending.isEmpty) {
          print('   No pending notifications');
        } else {
          for (var notification in pending) {
            print('   - ID: ${notification.id}');
            print('     Title: ${notification.title}');
            print('     Body: ${notification.body}');
            print('     Payload: ${notification.payload}');
          }
        }

        // Print permission status
        final hasPermission = await areNotificationsEnabled();
        print('📱 Permission Status:');
        print('   Notifications enabled: $hasPermission');
      } catch (e) {
        print('❌ Error in debug print: $e');
      }
    }
  }

  /// Show an immediate test notification (for testing purposes)
  static Future<void> showTestNotification() async {
    try {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.high,
        priority: Priority.high,
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        999,
        'تذكير شرب الماء 💧',
        'هذا إشعار تجريبي - التذكيرات تعمل بنجاح!',
        details,
        payload: 'test_notification',
      );

      if (kDebugMode) {
        print('✅ Test notification shown');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error showing test notification: $e');
      }
    }
  }
}