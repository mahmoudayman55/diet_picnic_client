import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDropdownWidget<T> extends StatefulWidget {
  final String label;
  final bool dark;
  final Color color;
  final List<T> items;
  final void Function(T) onChanged;
  final T? initialValue;
  final T? selectedItem;

  const CustomDropdownWidget({
    Key? key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.dark = false,
    this.initialValue,
    this.selectedItem,
    required this.color,
  }) : super(key: key);

  @override
  _CustomDropdownWidgetState<T> createState() => _CustomDropdownWidgetState<T>();
}

class _CustomDropdownWidgetState<T> extends State<CustomDropdownWidget<T>> {
  late T? selectedItem;

  @override
  void initState() {
    super.initState();
    // Corrected initialization
    selectedItem = widget.initialValue ??
        (widget.items.isNotEmpty ? widget.items.first : null);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label.capitalizeFirst!.tr,
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .copyWith(color: widget.dark ? CustomColors.textBlack54 : Colors.white),
        ),
        SizedBox(height: 5,),
        Container(
          width: width,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DropdownButton<T>(
              underline: const SizedBox.shrink(),
              hint: Text(
                widget.selectedItem == null
                    ? 'اختر' // Default hint text when selectedItem is null
                    : widget.selectedItem.toString().capitalizeFirst!.tr,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: widget.dark ? CustomColors.textBlack54 : Colors.white),
              ),
              onChanged: (value) {
                setState(() {
                  selectedItem = value;
                });
                if (value != null) {
                  widget.onChanged(value);
                }
              },
              selectedItemBuilder: (BuildContext context) {
                return widget.items.map<Widget>((item) {
                  return DropdownMenuItem(
                    value: item,
                    child: Text(
                      item.toString().capitalizeFirst!.tr,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(color: widget.dark ? CustomColors.textBlack54 : Colors.white),
                    ),
                  );
                }).toList();
              },
              items: widget.items.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    item.toString().capitalizeFirst!.tr,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: CustomColors.textBlack54),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
