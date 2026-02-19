import 'package:diet_picnic_client/controller/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/custom_colors.dart';

class QuestionMultiSelectWidget extends StatelessWidget {
  final String question;
  final List<String> options;
  final RxList<String> selectedOptions;
  final Function(String) onSelect;

  const QuestionMultiSelectWidget({
    super.key,
    required this.question,
    required this.options,
    required this.selectedOptions,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              question,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: options.map((option) {
                final isSelected = selectedOptions.contains(option);
                final isAppDark = ThemeController.to.isDarkMode;
                return GestureDetector(
                  onTap: () => onSelect(option),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isAppDark
                              ? CustomColors.mainColor.withOpacity(0.3)
                              : CustomColors.mainColor.withOpacity(0.15))
                          : (isAppDark
                              ? Colors.white.withOpacity(0.1)
                              : Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? CustomColors.mainColor
                            : (isAppDark
                                ? Colors.grey.shade700
                                : Colors.grey.shade400),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      option,
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                color: isSelected
                                    ? (isAppDark
                                        ? Colors.white
                                        : CustomColors.mainColor)
                                    : (isAppDark
                                        ? Colors.white70
                                        : Colors.grey.shade800),
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    });
  }
}

class QuestionSingleSelectWidget<T> extends StatelessWidget {
  final String question;
  final List<T> options;
  final T? selectedOption;
  final String Function(T) labelBuilder;
  final Function(T) onSelect;

  const QuestionSingleSelectWidget({
    Key? key,
    required this.question,
    required this.options,
    required this.selectedOption,
    required this.labelBuilder,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            question,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: options.map((option) {
              final isSelected = selectedOption == option;
              final isAppDark = ThemeController.to.isDarkMode;
              return GestureDetector(
                onTap: () => onSelect(option),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isAppDark
                            ? CustomColors.mainColor.withOpacity(0.3)
                            : CustomColors.mainColor.withOpacity(0.15))
                        : (isAppDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? CustomColors.mainColor
                          : (isAppDark
                              ? Colors.grey.shade700
                              : Colors.grey.shade400),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    labelBuilder(option),
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: isSelected
                              ? (isAppDark
                                  ? Colors.white
                                  : CustomColors.mainColor)
                              : (isAppDark
                                  ? Colors.white70
                                  : Colors.grey.shade800),
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
