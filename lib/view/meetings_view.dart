import 'package:diet_picnic_client/components/custom_app_bar.dart';
import 'package:diet_picnic_client/components/custom_url_luncher.dart';
import 'package:diet_picnic_client/components/logo_loading_widget.dart';
import 'package:diet_picnic_client/controller/meetings_controller.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/models/meeting_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class MeetingsView extends GetView<MeetingsController> {
  const MeetingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "الإجتماعات"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: LogoLoadingWidget());
        }

        final upcoming = controller.upcomingMeetings;
        final past = controller.pastMeetings;

        if (upcoming.isEmpty && past.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Iconsax.video_slash,
                    size: 60, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'لا توجد اجتماعات حالياً',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.grey.shade500,
                      ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.fetchMeetings,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // --- Upcoming ---
              if (upcoming.isNotEmpty) ...[
                // _SectionHeader(
                //   label: 'الاجتماعات القادمة',
                //   icon: Iconsax.calendar_tick,
                //   color: CustomColors.mainColor,
                // ),
                const SizedBox(height: 8),
                ...upcoming.map((m) => _MeetingCard(
                      meeting: m,
                      showJoinButton: true,
                    )),
              ],

              // --- Past ---
              if (past.isNotEmpty) ...[
                const SizedBox(height: 24),
                _SectionHeader(
                  label: 'الاجتماعات السابقة',
                  icon: Iconsax.calendar_remove,
                  color: Colors.grey,
                ),
                const SizedBox(height: 8),
                ...past.map((m) => _MeetingCard(
                      meeting: m,
                      showJoinButton: false,
                    )),
              ],
            ],
          ),
        );
      }),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _SectionHeader({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _MeetingCard extends StatelessWidget {
  final MeetingModel meeting;
  final bool showJoinButton;

  const _MeetingCard({
    required this.meeting,
    required this.showJoinButton,
  });

  @override
  Widget build(BuildContext context) {
    final bool isUpcoming = meeting.isUpcoming;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUpcoming
              ? CustomColors.mainColor.withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row with status badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    meeting.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            // Description
            if (meeting.description.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                meeting.description,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Date & Time
            Row(
              children: [
                const Icon(Iconsax.calendar,
                    size: 16, color: CustomColors.mainColor),
                const SizedBox(width: 6),
                Text(
                  meeting.date,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(width: 16),
                const Icon(Iconsax.clock,
                    size: 16, color: CustomColors.mainColor),
                const SizedBox(width: 6),
                Text(
                  meeting.time,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),

            // Join button
            if (showJoinButton && meeting.joinUrl.isNotEmpty) ...[
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: (meeting.hasStarted && !meeting.hasExpired)
                      ? () => CustomUrlLauncher.launchWebUrl(meeting.joinUrl)
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: meeting.hasExpired
                        ? Colors.red.shade50
                        : meeting.hasStarted
                            ? CustomColors.mainColor
                            : Colors.grey.shade300,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: meeting.hasExpired
                        ? Colors.red.shade50
                        : Colors.grey.shade300,
                    disabledForegroundColor: meeting.hasExpired
                        ? Colors.red.shade400
                        : Colors.grey.shade500,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  icon: Icon(
                    meeting.hasExpired
                        ? Icons.cancel_outlined
                        : meeting.hasStarted
                            ? Icons.arrow_circle_right_outlined
                            : Icons.access_time_rounded,
                    size: 18,
                  ),
                  label: Text(
                    meeting.hasExpired
                        ? 'انتهى الاجتماع'
                        : meeting.hasStarted
                            ? 'انضم الآن'
                            : 'لم يبدأ بعد',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: meeting.hasExpired
                              ? Colors.red.shade400
                              : meeting.hasStarted
                                  ? Colors.white
                                  : Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
