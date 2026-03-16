import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/core/theme.dart';
import 'package:diet_picnic_client/view/add_progrss_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeeklyFollowUpCard extends StatelessWidget {
  const WeeklyFollowUpCard({super.key});

  // Color get _bgColor {
  //   final d = DateTime
  //       .now()
  //       .weekday;
  //   if (d == DateTime.thursday) return Colors.red.shade50;
  //   if (d == DateTime.wednesday) return Colors.orange.shade50;
  //   return Colors.blue.shade50;
  // }
  MaterialColor get _accentColor {
    final d = DateTime.now().weekday;
    if (d == DateTime.wednesday) return Colors.red;    // Last day of week
    if (d == DateTime.tuesday) return Colors.orange;   // One day left
    return Colors.blue;
  }

  String get _message {
    final d = DateTime.now().weekday;
    if (d == DateTime.wednesday) {
      return 'انهارده آخر فرصة — لازم تبعت المتابعة الأسبوعية انهارده';
    }
    if (d == DateTime.tuesday) {
      return 'فاضل يومين بس — يفضل تبعت المتابعة الأسبوعية قبل نهاية الأسبوع';
    }
    return 'تذكير: متنساش تبعت المتابعة الأسبوعية قبل نهاية الأسبوع';
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accentColor;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => Get.to(AddWeekProgressView()),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(border: Border.all(color: _accentColor),
          color: _accentColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.notifications_none,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // Text column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'المتابعة الأسبوعية',
                    style: Themes.lightTheme.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: accent.shade700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _message,
                    style: Themes.lightTheme.textTheme.displaySmall?.copyWith(
                      color: accent.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
