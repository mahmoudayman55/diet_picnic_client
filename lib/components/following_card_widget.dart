import 'package:diet_picnic_client/components/animated_column.dart';
import 'package:diet_picnic_client/core/date_time_formater.dart';
import 'package:diet_picnic_client/models/week_progress_model.dart';
import 'package:flutter/material.dart';

import '../core/custom_colors.dart';

Widget buildCompareProgressWidget(
    BuildContext context,
    WeekProgressModel firstProgress,
    WeekProgressModel lastProgress,
    ) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
      border: Border.all(
        color: CustomColors.borderColor,
        width: 1,
      ),
    ),
    child: AnimatedColumn(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Text(
        //   "🎯",
        //   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
        //     color: CustomColors.selectedNavBarColor,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        // const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildProgressColumn(context, "قبل", firstProgress),
            Container(
              height: 130,
              width: 1,
              color: CustomColors.borderColor,
            ),
            _buildProgressColumn(context, "بعد", lastProgress),
          ],
        ),
        const SizedBox(height: 16),
        _buildComparisonRow(context, "الوزن", firstProgress.weight, lastProgress.weight, "assets/images/weight.png"),
        _buildComparisonRow(context, "الحوض", firstProgress.pelvis, lastProgress.pelvis, "assets/images/palvies.png"),
        _buildComparisonRow(context, "وسط الذراع", firstProgress.rightArm, lastProgress.rightArm, "assets/images/arm.png"),
        _buildComparisonRow(context, "الوسط", firstProgress.waist, lastProgress.waist, "assets/images/waist.png"),
        const SizedBox(height: 10),

      ],
    ),
  );
}

Widget _buildProgressColumn(BuildContext context, String label, WeekProgressModel progress) {
  return Column(
    children: [
      Text(
        label,
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
          color: CustomColors.mainColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        DateTimeFormatter.dateTimeToFullDate(progress.date),
        style: Theme.of(context).textTheme.displayLarge?.copyWith(
          color: CustomColors.textBlack54,
        ),
      ),
    ],
  );
}

Widget _buildComparisonRow(
    BuildContext context,
    String label,
    double? before,
    double? after,
    String image,
    ) {
  final difference = (after ?? 0) - (before ?? 0);
  final diffColor = difference < 0 ? Colors.green : difference > 0 ? Colors.red : Colors.grey;

  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(image, width: 24, height: 24, color: CustomColors.selectedNavBarColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: CustomColors.textBlack87,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "${before ?? '-'}",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.grey),
            const SizedBox(width: 6),
            Text(
              "${after ?? '-'}",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: CustomColors.selectedNavBarColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "(${difference.toStringAsFixed(1)})",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: diffColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
