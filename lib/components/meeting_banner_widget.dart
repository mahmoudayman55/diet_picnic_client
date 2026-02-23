import 'package:diet_picnic_client/components/custom_url_luncher.dart';
import 'package:diet_picnic_client/controller/meetings_controller.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class MeetingBannerWidget extends StatelessWidget {
  const MeetingBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MeetingsController>();

    return Obx(() {
      if (controller.isLoading.value) return const SizedBox.shrink();

      final meeting = controller.nextMeeting;
      if (meeting == null) return const SizedBox.shrink();

      return InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Get.toNamed(AppConstants.meetingsPage),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: CustomColors.mainColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Icon container — brand orange
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: CustomColors.mainColor,
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
                      'الاجتماع القادم : ${meeting.title}',
                      style: Themes.lightTheme.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mainColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Iconsax.calendar,
                            size: 12, color: CustomColors.mainColor),
                        const SizedBox(width: 4),
                        Text(
                          meeting.date,
                          style: Themes.lightTheme.textTheme.displaySmall
                              ?.copyWith(
                            color: CustomColors.mainColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Iconsax.clock,
                            size: 12, color: CustomColors.mainColor),
                        const SizedBox(width: 4),
                        Text(
                          meeting.time,
                          style: Themes.lightTheme.textTheme.displaySmall
                              ?.copyWith(
                            color: CustomColors.mainColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Join icon button — 3 states: expired / active / not yet
              if (meeting.joinUrl.isNotEmpty)
                IconButton(
                  onPressed: (meeting.hasStarted && !meeting.hasExpired)
                      ? () => CustomUrlLauncher.launchWebUrl(meeting.joinUrl)
                      : null,
                  style: IconButton.styleFrom(
                    backgroundColor: meeting.hasExpired
                        ? Colors.red.shade100
                        : meeting.hasStarted
                            ? CustomColors.mainColor
                            : Colors.grey.shade300,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: meeting.hasExpired
                        ? Colors.red.shade100
                        : Colors.grey.shade300,
                    disabledForegroundColor: meeting.hasExpired
                        ? Colors.red.shade400
                        : Colors.grey.shade500,
                    padding: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  tooltip: meeting.hasExpired ? 'انتهى الاجتماع' : null,
                  icon: Icon(
                    meeting.hasExpired
                        ? Icons.cancel_outlined
                        : meeting.hasStarted
                            ? Icons.arrow_circle_right_outlined
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
