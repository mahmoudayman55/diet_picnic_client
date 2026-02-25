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

class ExamQuestionWidget extends StatelessWidget {
  final String question;
  final List<String> options;
  final int? selectedOption;
  final Function(int) onSelect;

  const ExamQuestionWidget({
    super.key,
    required this.question,
    required this.options,
    required this.selectedOption,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isAppDark = ThemeController.to.isDarkMode;
    final primaryColor = CustomColors.selectedNavBarColor;
    final lightPrimary = primaryColor.withOpacity(0.1);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Question Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            decoration: BoxDecoration(
              color: isAppDark ? Colors.white.withOpacity(0.05) : lightPrimary,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isAppDark
                    ? Colors.grey.shade800
                    : primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              question,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: isAppDark ? Colors.white : Colors.black87,
                  ),
            ),
          ),
          const SizedBox(height: 30),
          // Options List
          ...List.generate(options.length, (index) {
            final isSelected = selectedOption == index;
            final letter = String.fromCharCode(65 + index); // A, B, C, D...

            return GestureDetector(
              onTap: () => onSelect(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isAppDark
                          ? primaryColor.withOpacity(0.2)
                          : lightPrimary)
                      : (isAppDark ? Colors.black26 : Colors.white),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? primaryColor
                        : (isAppDark
                            ? Colors.grey.shade800
                            : Colors.grey.shade200),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    if (!isSelected && !isAppDark)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        options[index],
                        textAlign: TextAlign.right,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                              color: isSelected
                                  ? (isAppDark ? Colors.white : primaryColor)
                                  : (isAppDark
                                      ? Colors.white70
                                      : Colors.black87),
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Letter Bubble
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? primaryColor
                            : (isAppDark
                                ? Colors.white10
                                : Colors.grey.shade100),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        letter,
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : (isAppDark
                                          ? Colors.white54
                                          : Colors.grey.shade500),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
