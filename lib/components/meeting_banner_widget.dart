import 'package:diet_picnic_client/components/custom_snack_bar.dart';
import 'package:diet_picnic_client/components/custom_url_luncher.dart';
import 'package:diet_picnic_client/controller/meetings_controller.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class MeetingBannerWidget extends StatelessWidget {
  final bool? debugIsLoading;
  final bool? debugHasStarted;
  final bool? debugHasExpired;
  final String? debugJoinUrl;
  final String? debugTitle;
  final String? debugDate;
  final String? debugTime;

  const MeetingBannerWidget({
    super.key,
    this.debugIsLoading,
    this.debugHasStarted,
    this.debugHasExpired,
    this.debugJoinUrl,
    this.debugTitle,
    this.debugDate,
    this.debugTime,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      MeetingsController? controller;
      if (Get.isRegistered<MeetingsController>()) {
        controller = Get.find<MeetingsController>();
      }

      // Track Rx properties properly when available
      final isControllerLoading = controller?.isLoading.value ?? false;
      final actualMeeting =
          controller?.nextMeeting; // evaluates getters to track Rx changes

      final isLoading = debugIsLoading ?? isControllerLoading;
      if (isLoading) return const SizedBox.shrink();

      final isDebug = debugTitle != null ||
          debugHasStarted != null ||
          debugHasExpired != null ||
          debugJoinUrl != null;

      if (actualMeeting == null && !isDebug) {
        return const SizedBox.shrink();
      }

      final title = debugTitle ?? actualMeeting?.title ?? 'اجتماع تجريبي';
      final date = debugDate ?? actualMeeting?.date ?? '2024-01-01';
      final time = debugTime ?? actualMeeting?.time ?? '10:00 AM';
      final joinUrl =
          debugJoinUrl ?? actualMeeting?.joinUrl ?? 'https://debug.com';
      final hasStarted = debugHasStarted ?? actualMeeting?.hasStarted ?? false;
      final hasExpired = debugHasExpired ?? actualMeeting?.hasExpired ?? false;

      final statusColor = hasExpired
          ? Colors.red
          : hasStarted
              ? Colors.green.shade600
              : CustomColors.mainColor;

      final statusBgColor = hasExpired
          ? Colors.red.withOpacity(0.1)
          : hasStarted
              ? Colors.green.withOpacity(0.1)
              : CustomColors.mainColor.withOpacity(0.1);

      // To avoid Obx throwing an error if no Rx variables were accessed because debug flags overrode everything
      // without Get.isRegistered checking out, we ensure at least one reactive lookup happens or we use Obx correctly.
      // But we already checked `controller?.isLoading.value` and `controller?.nextMeeting`.

      return InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Get.toNamed(AppConstants.meetingsPage),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: statusBgColor,border: Border.all(color: statusColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Icon container
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Iconsax.video,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // Title + date/time
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الاجتماع القادم : $title',
                      style: Themes.lightTheme.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Iconsax.calendar, size: 12, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          date,
                          style: Themes.lightTheme.textTheme.displaySmall
                              ?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(Iconsax.clock, size: 12, color: statusColor),
                        const SizedBox(width: 4),
                        Text(
                          time,
                          style: Themes.lightTheme.textTheme.displaySmall
                              ?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Copy URL Icon Button -- show only if running
              if (joinUrl.isNotEmpty && hasStarted && !hasExpired)
                IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: joinUrl));
                    showCustomSnackbar(
                      title: "تم النسخ",
                      message: "تم نسخ رابط الاجتماع بنجاح",
                      successful: true,
                    );
                  },
                  icon: Icon(
                    Iconsax.copy,
                    color: statusColor,
                    size: 20,
                  ),
                ),

              // Join icon button — 3 states: expired / active / not yet
              if (joinUrl.isNotEmpty)
                IconButton(
                  onPressed: (hasStarted && !hasExpired)
                      ? () => CustomUrlLauncher.launchWebUrl(joinUrl)
                      : null,
                  style: IconButton.styleFrom(
                    backgroundColor: hasExpired
                        ? Colors.red
                        : hasStarted
                            ? statusColor
                            : Colors.grey.shade300,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor:
                        hasExpired ? Colors.red : Colors.grey.withOpacity(0.2),
                    disabledForegroundColor:
                        hasExpired ? Colors.white : Colors.grey.shade500,
                    padding: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  tooltip: hasExpired ? 'انتهى الاجتماع' : null,
                  icon: Icon(
                    hasExpired
                        ? Icons.cancel_outlined
                        : hasStarted
                            ? Icons.meeting_room_outlined
                            : Icons.access_time_rounded,
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
