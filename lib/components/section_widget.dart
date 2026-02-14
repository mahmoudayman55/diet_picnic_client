import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:flutter/material.dart';

class SectionWidget extends StatelessWidget {
  final String title;
  final Widget? sideWidget;
  final double? elevation;
  final List<Widget> children;
  final bool optional;
  final Color color;
  final VoidCallback? onTap; // ✅ Added onTap parameter

  const SectionWidget({
    super.key,
    required this.title,
    this.sideWidget,
    this.color = Colors.white,
    this.elevation,
    required this.children,
    this.optional = false,
    this.onTap, // ✅ Added here
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + optional side widget
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    optional ? "$title (Optional)" : title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: CustomColors.textBlack87,
                    ),
                  ),
                  if (sideWidget != null)
                    InkWell(
                      onTap: onTap, // ✅ Handles the tap action
                      borderRadius: BorderRadius.circular(8),
                      child: sideWidget!,
                    ),
                ],
              ),
            ),

            // Children
            ...children,
          ],
        ),
      ),
    );
  }
}
