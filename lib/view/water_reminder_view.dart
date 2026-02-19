import 'package:diet_picnic_client/components/custom_app_bar.dart';
import 'package:diet_picnic_client/controller/theme_controller.dart';

import 'package:diet_picnic_client/controller/water_reminder_controller.dart';
import 'package:diet_picnic_client/core/notification_test_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class WaterReminderView extends StatelessWidget {
  const WaterReminderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      final width = 100.w;
      final height = 100.h;
      bool isMobile = deviceType == DeviceType.mobile;
      return GetBuilder<WaterReminderController>(
        init: WaterReminderController(),
        builder: (controller) {
          return Scaffold(
            // backgroundColor: Themes.lightTheme.scaffoldBackgroundColor,
            appBar: CustomAppBar(
              title: 'تذكيرات شرب الماء',
            ),
            body: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return SingleChildScrollView(
                padding: EdgeInsets.all(width * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    _buildHeaderSection(controller, width),
                    // Action Buttons

                    SizedBox(height: height * 0.03),

                    // Main Toggle
                    _buildMainToggle(controller, width, height),

                    SizedBox(height: height * 0.03),

                    // Notification Status
                    _buildNotificationStatus(controller, width, height),
                    SizedBox(height: height * 0.03),
                    _buildActionButtons(controller, width, height),
                    SizedBox(height: height * 0.03),

                    // Reminders List
                    _buildRemindersList(controller, width, height),

                    // Debug/Test Section (only in debug mode)
                    if (kDebugMode) ...[
                      SizedBox(height: height * 0.03),
                      _buildTestSection(controller, width, height),
                    ],
                  ],
                ),
              );
            }),
          );
        },
      );
    });
  }

  Widget _buildHeaderSection(WaterReminderController controller, double width) {
    final isDark = ThemeController.to.isDarkMode;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  Colors.blue.shade900,
                  Colors.blue.shade800,
                ]
              : [
                  Colors.blue.shade100,
                  Colors.blue.shade50,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(width * 0.02),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.water_drop,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              SizedBox(width: width * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تذكيرات شرب الماء',
                      style: Theme.of(Get.context!)
                          .textTheme
                          .displayLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.blue.shade800,
                          ),
                    ),
                    Text(
                      'احصل على تذكيرات منتظمة لشرب الماء طوال اليوم',
                      style: Theme.of(Get.context!)
                          .textTheme
                          .displaySmall
                          ?.copyWith(
                            color: isDark
                                ? Colors.blue.shade100
                                : Colors.blue.shade600,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainToggle(
      WaterReminderController controller, double width, double height) {
    final isDark = ThemeController.to.isDarkMode;
    return Container(
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تفعيل التذكيرات',
                  style:
                      Theme.of(Get.context!).textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                ),
                SizedBox(height: height * 0.01),
                Text(
                  'قم بتفعيل أو إيقاف جميع تذكيرات شرب الماء',
                  style:
                      Theme.of(Get.context!).textTheme.displaySmall?.copyWith(
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                ),
              ],
            ),
          ),
          Switch(
            value: controller.isEnabled.value,
            onChanged: controller.toggleReminders,
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationStatus(
      WaterReminderController controller, double width, double height) {
    final isDark = ThemeController.to.isDarkMode;
    final isEnabled = controller.areNotificationsEnabled.value;

    // Define colors based on state and theme
    final bgColor = isEnabled
        ? (isDark
            ? Colors.green.shade900.withOpacity(0.2)
            : Colors.green.shade50)
        : (isDark
            ? Colors.orange.shade900.withOpacity(0.2)
            : Colors.orange.shade50);

    final borderColor = isEnabled
        ? (isDark ? Colors.green.shade800 : Colors.green.shade200)
        : (isDark ? Colors.orange.shade800 : Colors.orange.shade200);

    final iconColor = isEnabled
        ? (isDark ? Colors.green.shade400 : Colors.green)
        : (isDark ? Colors.orange.shade400 : Colors.orange);

    final titleColor = isEnabled
        ? (isDark ? Colors.green.shade300 : Colors.green.shade800)
        : (isDark ? Colors.orange.shade300 : Colors.orange.shade800);

    final subtitleColor = isEnabled
        ? (isDark ? Colors.green.shade200 : Colors.green.shade600)
        : (isDark ? Colors.orange.shade200 : Colors.orange.shade600);

    return Container(
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isEnabled ? Icons.notifications_active : Icons.notifications_off,
            color: iconColor,
            size: 24,
          ),
          SizedBox(width: width * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEnabled ? 'الإشعارات مفعلة' : 'الإشعارات معطلة',
                  style:
                      Theme.of(Get.context!).textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: titleColor,
                          ),
                ),
                Text(
                  isEnabled
                      ? 'يمكنك تلقي التذكيرات'
                      : 'يرجى تفعيل الإشعارات في إعدادات الجهاز',
                  style:
                      Theme.of(Get.context!).textTheme.displaySmall?.copyWith(
                            color: subtitleColor,
                          ),
                ),
              ],
            ),
          ),
          if (!isEnabled)
            TextButton(
              onPressed: controller.openNotificationSettings,
              child: Text(
                'الإعدادات',
                style: TextStyle(
                    color: isDark
                        ? Colors.orange.shade300
                        : Colors.orange.shade700),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRemindersList(
      WaterReminderController controller, double width, double height) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'جدول التذكيرات',
          style: Theme.of(Get.context!).textTheme.displayLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: height * 0.02),
        ...controller.reminders
            .map((reminder) =>
                _buildReminderItem(controller, reminder, width, height))
            .toList(),
      ],
    );
  }

  Widget _buildReminderItem(WaterReminderController controller,
      WaterReminder reminder, double width, double height) {
    final isDark = ThemeController.to.isDarkMode;
    return Container(
      margin: EdgeInsets.only(bottom: height * 0.02),
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: Theme.of(Get.context!).cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: reminder.isEnabled
              ? (isDark ? Colors.blue.shade700 : Colors.blue.shade200)
              : (isDark ? Colors.grey.shade800 : Colors.grey.shade200),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Time and Message
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.02,
                            vertical: height * 0.01,
                          ),
                          decoration: BoxDecoration(
                            color: reminder.isEnabled
                                ? (isDark
                                    ? Colors.blue.shade900.withOpacity(0.5)
                                    : Colors.blue.shade100)
                                : (isDark
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade100),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            reminder.time,
                            style: Theme.of(Get.context!)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: reminder.isEnabled
                                      ? (isDark
                                          ? Colors.blue.shade200
                                          : Colors.blue.shade700)
                                      : (isDark
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade600),
                                ),
                          ),
                        ),
                        SizedBox(width: width * 0.02),
                        Icon(
                          Icons.water_drop,
                          color: reminder.isEnabled
                              ? Colors.blue
                              : (isDark
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade400),
                          size: 20,
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      reminder.message,
                      style: Theme.of(Get.context!)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    SizedBox(height: height * 0.005),
                    Text(
                      reminder.reason,
                      style: Theme.of(Get.context!)
                          .textTheme
                          .displaySmall
                          ?.copyWith(
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ),
              ),
              // Toggle Switch
              Switch(
                value: reminder.isEnabled,
                onChanged: (value) =>
                    controller.toggleIndividualReminder(reminder.id, value),
                activeColor: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
      WaterReminderController controller, double width, double height) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: controller.enableAllReminders,
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('تفعيل الكل'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: height * 0.02),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: controller.disableAllReminders,
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('إيقاف الكل'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: height * 0.02),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTestSection(
      WaterReminderController controller, double width, double height) {
    return Container(
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bug_report,
                color: Colors.orange.shade700,
                size: 24,
              ),
              SizedBox(width: width * 0.02),
              Text(
                '🧪 Debug/Test Tools',
                style: Theme.of(Get.context!).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                    ),
              ),
            ],
          ),
          SizedBox(height: height * 0.02),
          Text(
            'Use these tools to test the notification system (Debug mode only)',
            style: Theme.of(Get.context!).textTheme.displaySmall?.copyWith(
                  color: Colors.orange.shade600,
                ),
          ),
          SizedBox(height: height * 0.02),
          Wrap(
            spacing: width * 0.02,
            runSpacing: height * 0.01,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  await NotificationTestHelper.testImmediateNotification();
                  Get.snackbar(
                    'Test Scheduled',
                    'Test notification scheduled for 1 minute from now',
                    backgroundColor: Colors.blue,
                    colorText: Colors.white,
                  );
                },
                icon: const Icon(Icons.notifications_active),
                label: const Text('Test Now'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await NotificationTestHelper.testAllWaterReminders();
                  Get.snackbar(
                    'Test Reminders',
                    'Test reminders scheduled for 2, 4, and 6 minutes',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                icon: const Icon(Icons.water_drop),
                label: const Text('Test Schedule'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await NotificationTestHelper.checkNotificationStatus();
                  await NotificationTestHelper.verifyDailyRepetition();
                  Get.snackbar(
                    'Status Check',
                    'Check console/debug output for status report',
                    backgroundColor: Colors.purple,
                    colorText: Colors.white,
                  );
                },
                icon: const Icon(Icons.info),
                label: const Text('Check Status'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await NotificationTestHelper.verifyDailyRepetition();
                  Get.snackbar(
                    'Daily Repetition',
                    'Check console for daily repetition verification',
                    backgroundColor: Colors.teal,
                    colorText: Colors.white,
                  );
                },
                icon: const Icon(Icons.repeat),
                label: const Text('Verify Daily'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await NotificationTestHelper.cancelTestNotifications();
                  Get.snackbar(
                    'Test Cleared',
                    'All test notifications cancelled',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                },
                icon: const Icon(Icons.clear),
                label: const Text('Clear Tests'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
