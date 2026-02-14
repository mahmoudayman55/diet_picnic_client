import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class OfferPriceWidget extends StatelessWidget {
  final double oldPrice;
  final double offerPrice;
  final Color oldPriceColor;
  final Color offerPriceColor;
  final MainAxisAlignment mainAxisAlignment;

  const OfferPriceWidget({
    super.key,
    required this.oldPrice,
    required this.offerPrice,
     this.mainAxisAlignment =MainAxisAlignment.center,
    this.oldPriceColor = Colors.grey,
    this.offerPriceColor = CustomColors.selectedNavBarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,mainAxisAlignment: mainAxisAlignment,
      children: [
        // السعر القديم
        Text(
          "${oldPrice.toStringAsFixed(0)}ج",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: oldPriceColor,
            decoration: TextDecoration.lineThrough,
            decorationColor: oldPriceColor,
            decorationThickness: 2,
          ),
        ),
        const SizedBox(width: 8),
        // السعر الجديد
        Text(
          "${offerPrice.toStringAsFixed(0)}ج",
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
            color: offerPriceColor,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }
}
