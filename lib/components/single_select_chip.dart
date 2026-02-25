import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:flutter/material.dart';

/// A reusable multi-select chip wrap widget.
class MultiSelectChipWrap<T> extends StatelessWidget {
  final List<T> items;
  // final String title;
  final bool isRequired;
  final List<T> selectedItems;
  final String Function(T) labelBuilder;
  final void Function(T) onTap;
  final VoidCallback? onSelectAll; // Select all
  final VoidCallback? onDeselectAll; // Deselect all
  final Color selectedBackgroundColor;
  final Color selectedTextColor;
  final Color unselectedBorderColor;
  final Color unselectedTextColor;

  const MultiSelectChipWrap({
    Key? key,
    required this.items,
    //required this.title,
    required this.selectedItems,
    required this.labelBuilder,
    required this.onTap,
    this.onSelectAll,
    this.onDeselectAll,
    this.selectedBackgroundColor = const Color(0xFFF3E4EA),
    this.selectedTextColor = CustomColors.selectedNavBarColor,
    this.unselectedBorderColor = CustomColors.selectedNavBarColor,
    this.unselectedTextColor = CustomColors.selectedNavBarColor,
    this.isRequired = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool allSelected = selectedItems.length == items.length;
    bool hasSelection = selectedItems.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          //    Text(title, style: Theme.of(context).textTheme.displayMedium),


              Row(
                children: [
                  if (onSelectAll != null && !allSelected)
                    TextButton(
                      onPressed: onSelectAll,
                      child: const Text("تحديد الكل"),
                    ),
                  if (onDeselectAll != null && hasSelection)
                    TextButton(
                      onPressed: onDeselectAll,
                      child: const Text("إلغاء الكل"),
                    ),
                ],
              ),
            ],
          ),
        ),
        Wrap(
          spacing: 24.0,
          runSpacing: 16.0,
          children: items.map((item) {
            final isSelected = selectedItems.contains(item);
            return GestureDetector(
              onTap: () => onTap(item),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? selectedBackgroundColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  border: isSelected
                      ? null
                      : Border.all(color: unselectedBorderColor, width: 1),
                ),
                child: Text(
                  labelBuilder(item),
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: isSelected
                        ? selectedTextColor
                        : unselectedTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }).toList(),
        ),

      ],
    );
  }
}

/// A reusable single-select chip wrap widget.
class SingleSelectChipWrap<T> extends StatelessWidget {
  final List<T> items;
 // final String title;
  final T? selectedItem;
  final bool isRequired;
  final String Function(T) labelBuilder;
  final void Function(T) onTap;
  final Color selectedBackgroundColor;
  final Color selectedTextColor;
  final Color unselectedBorderColor;
  final Color unselectedTextColor;

  const SingleSelectChipWrap({
    Key? key,
    required this.items,
  //  required this.title,
    required this.selectedItem,
    required this.labelBuilder,
    required this.onTap,
    this.isRequired=true,
    this.selectedBackgroundColor = const Color(0xFFF3E4EA),
    this.selectedTextColor = CustomColors.selectedNavBarColor,
    this.unselectedBorderColor = CustomColors.selectedNavBarColor,
    this.unselectedTextColor = CustomColors.selectedNavBarColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 5.0),
        //   child: Text(title, style: Theme.of(context).textTheme.displayMedium),
        // ),
        Wrap(
          spacing: 24.0,
          runSpacing: 16.0,
          children: items.map((item) {
            final isSelected = selectedItem != null && item == selectedItem;
            return GestureDetector(
              onTap: () => onTap(item),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? selectedBackgroundColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                  border: isSelected
                      ? null
                      : Border.all(color: unselectedBorderColor, width: 1),
                ),
                child: Text(
                  labelBuilder(item),
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: isSelected ? selectedTextColor : unselectedTextColor,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }).toList(),
        ),

      ],
    );
  }
}
