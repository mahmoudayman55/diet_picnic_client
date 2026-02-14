import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart'; // if you use iconsax package

class MenuButtonWidget extends StatelessWidget {
  final IconData leadingIcon;
  final Widget sideWidget;
  final String title;
  final VoidCallback? onTap;

  const MenuButtonWidget({
    Key? key,
    required this.leadingIcon,
     this.sideWidget = const Icon(Icons.chevron_right, color: Colors.grey),
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(margin: EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(leadingIcon, color: Colors.black87),
                ),
                Text(
                  title,
                  style: textTheme.bodyMedium, // changed from displayMedium
                ),
              ],
            ),
             sideWidget,
          ],
        ),
      ),
    );
  }
}
