import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:flutter/material.dart';

class DatePickerChip extends StatelessWidget {
  final DateTime? value;
  final String placeholder;
  final void Function(DateTime) onDateSelected;
  final Color backgroundColor;
  final Color textColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final BorderRadiusGeometry borderRadius;

  const DatePickerChip({
    Key? key,
    required this.value,
    required this.onDateSelected,
    this.placeholder = "MM.DD.YYYY",
    this.backgroundColor =CustomColors.softDarkRose,
    this.textColor =  CustomColors.selectedNavBarColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.margin = const EdgeInsets.symmetric(vertical: 8),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (picked != null) onDateSelected(picked);
      },
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(placeholder,style: Theme.of(context).textTheme.displayMedium,),
          Container(
            padding: padding,
            margin: margin,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: borderRadius,
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value == null
                      ? placeholder
                      : "${value!.year}/${value!.month}/${value!.day}",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(color: textColor),
                ),
                Icon(Icons.date_range,color: CustomColors.selectedNavBarColor,)
              ],
            ),
          ),
        ],
      ),
    );
  }
}