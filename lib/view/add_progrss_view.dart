import 'package:diet_picnic_client/components/custom_text_form_field.dart';
import 'package:diet_picnic_client/components/date_picker_chip_widget.dart';
import 'package:diet_picnic_client/controller/add_week_progress_controller.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';

class AddWeekProgressView extends StatelessWidget {
  const AddWeekProgressView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Avoid duplicate instance creation
    final controller = Get.put(AddWeekProgressController());

    final isEditing = controller.initialModel != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'تعديل التقدم الأسبوعي' : 'إضافة تقدم أسبوعي',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        foregroundColor: Colors.white,
      ),
      // backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GetBuilder<AddWeekProgressController>(builder: (c) {
          return WillPopScope(
            onWillPop: () async {
              c.previousStep();
              return false;
            },
            child: Column(
              children: [
                // Top Step Indicator Bar
                Obx(() => _buildStepProgressIndicator(context, c)),
                const SizedBox(height: 16),

                // Main Content View based on current step
                Expanded(
                  child: Form(
                    key: c.formKey,
                    child: Obx(() {
                      if (c.successMessage.value.isNotEmpty &&
                          c.currentStep.value == c.totalSteps.value) {
                        return _buildSuccessStep(context, c);
                      }
                      return _buildCurrentStepView(context, c);
                    }),
                  ),
                ),

                // Bottom controls
                Obx(() {
                  if (c.successMessage.value.isNotEmpty &&
                      c.currentStep.value == c.totalSteps.value) {
                    return const SizedBox
                        .shrink(); // Hide buttons on success screen
                  }
                  if (c.currentStep.value == 0) {
                    return const SizedBox
                        .shrink(); // Hide bottom controls on choice screen
                  }
                  return _buildBottomControls(context, c);
                }),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepProgressIndicator(
      BuildContext context, AddWeekProgressController c) {
    if (c.currentStep.value == 0) {
      return const SizedBox
          .shrink(); // No progress indicator on the very first choice screen
    }

    // Determine the text and progress value
    String stepText = '';
    double progressValue = 0.0;

    if (c.isExcuseFlow.value) {
      stepText = ' ${c.currentStep.value} / 2';
      progressValue = c.currentStep.value / 2;
    } else {
      stepText = ' ${c.currentStep.value} / 6';
      progressValue = c.currentStep.value / 6;
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(stepText, style:  Theme.of(context).textTheme.displaySmall),
          ],
        ),
        const SizedBox(height: 8),
        // Custom dot/dash indicator style instead of continuous bar
        Row(
          children: List.generate(c.totalSteps.value - 1, (index) {
            final int stepIndex = index + 1; // logical step index
            final bool isActive = c.currentStep.value >= stepIndex;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                height: 8,
                decoration: BoxDecoration(
                  color: isActive
                      ? CustomColors.mainColor
                      : CustomColors.mainColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }),
        )
      ],
    );
  }

  Widget _buildCurrentStepView(
      BuildContext context, AddWeekProgressController c) {
    if (c.currentStep.value == 0) return _buildChoiceStep(context, c);

    if (c.isExcuseFlow.value) {
      if (c.currentStep.value == 1) return _buildExcuseStep(context, c);
    } else {
      switch (c.currentStep.value) {
        case 1:
          return _buildWeightStep(context, c);
        case 2:
          return _buildWaistStep(context, c);
        case 3:
          return _buildPelvisStep(context, c);
        case 4:
          return _buildArmStep(context, c);
        case 5:
          return _buildNotesAndDateStep(context, c);
        case 6:
          return _buildConfirmationSummaryStep(context, c);
      }
    }
    return const SizedBox.shrink();
  }

  Widget _buildChoiceStep(BuildContext context, AddWeekProgressController c) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.show_chart, size: 64, color: CustomColors.mainColor),
        const SizedBox(height: 24),
        Text('كيف حال تقدمك هذا الأسبوع؟',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
         Text(
            'يسعدنا متابعة رحلتك الصحية. يرجى اختيار الخيار المناسب لك اليوم.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.grey)),
        const SizedBox(height: 48),
        InkWell(
          onTap: () => c.selectFlow(false),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: CustomColors.mainColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.scale, color: CustomColors.mainColor),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('إرسال التقدم الأسبوعي',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('تحديث الوزن والقياسات الحيوية',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        InkWell(
          onTap: () => c.selectFlow(true),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.event_busy, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('لدي عذر',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('لا أستطيع إرسال المتابعة هذا الأسبوع',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExcuseStep(BuildContext context, AddWeekProgressController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text('ما هو عذرك؟',
            style:Theme.of(context).textTheme.headlineLarge ),
        const SizedBox(height: 8),
         Text('يرجى كتابة تفاصيل العذر بوضوح ليتمكن الفريق من مراجعته.',
            style: Theme.of(context).textTheme.displayMedium),
        const SizedBox(height: 24),
        CustomTextFormField(
          context: context,
          isRequired: true,
          label: 'اكتب عذرك هنا بالتفصيل...',
          controller: c.excuseController,
          maxLines: 8,
        ),
        if (c.errorMessage.value.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(c.errorMessage.value,
                style: const TextStyle(color: Colors.red)),
          )
      ],
    );
  }

  Widget _buildWeightStep(BuildContext context, AddWeekProgressController c) {
    return _buildMeasureInputStep(
      context: context,
      controller: c,
      title: 'ما هو وزنك اليوم؟',
      label: 'الوزن (كجم)',
      textController: c.weightController,
      description: 'يساعد تتبع وزنك بانتظام في فهم تقدمك نحو أهدافك الصحية.',
    );
  }

  Widget _buildWaistStep(BuildContext context, AddWeekProgressController c) {
    return _buildMeasureInputStep(
      context: context,
      controller: c,
      title: 'مقاس الوسط',
      label: 'سم',
      textController: c.waistController,
      description: 'شريط القياس يجب ان يكون موازياً للأرض',
    );
  }

  Widget _buildPelvisStep(BuildContext context, AddWeekProgressController c) {
    if (c.pelvisController.text.isEmpty) c.pelvisController.text = '40.00';
    return _buildMeasureInputStep(
      context: context,
      controller: c,
      title: 'مقاس الحوض',
      label: 'سم',
      textController: c.pelvisController,
      description: 'مقاس الحوض يضمن دقة تتبع شكل الجسم.',
    );
  }

  Widget _buildArmStep(BuildContext context, AddWeekProgressController c) {
    if (c.rightArmController.text.isEmpty) c.rightArmController.text = '30.00';
    return _buildMeasureInputStep(
      context: context,
      controller: c,
      title: 'مقاس وسط الذراع',
      label: 'سم',
      textController: c.rightArmController,
      description: 'مقاس وسط الذراع يساعد في تتبع مستوى العضلات.',
    );
  }

  Widget _buildNotesAndDateStep(
      BuildContext context, AddWeekProgressController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        const Text('التاريخ والملاحظات',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 32),
        DatePickerChip(
          value: c.selectedDate.value,
          placeholder: 'التاريخ',
          onDateSelected: c.setDate,
        ),
        const SizedBox(height: 24),
        CustomTextFormField(
          context: context,
          isRequired: false,
          label: 'ملاحظات إضافية (اختياري)',
          maxLines: 5,
          controller: c.notesController,
        ),
        if (c.errorMessage.value.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(c.errorMessage.value,
                style: const TextStyle(color: Colors.red)),
          )
      ],
    );
  }

  Widget _buildConfirmationSummaryStep(
      BuildContext context, AddWeekProgressController c) {
    String formatValue(String text) {
      double? val = double.tryParse(text);
      if (val == null) return text;
      return val % 1 == 0 ? val.toInt().toString() : val.toString();
    }

    return ListView(
      children: [
        const SizedBox(height: 16),
        const Text('تأكيد البيانات',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        const SizedBox(height: 32),
        _buildSummaryRow(
            'الوزن', '${formatValue(c.weightController.text)} كجم'),
        const Divider(),
        _buildSummaryRow(
            'مقاس الوسط', '${formatValue(c.waistController.text)} سم'),
        const Divider(),
        _buildSummaryRow(
            'مقاس الحوض', '${formatValue(c.pelvisController.text)} سم'),
        const Divider(),
        _buildSummaryRow(
            'مقاس وسط الذراع', '${formatValue(c.rightArmController.text)} سم'),

        const Divider(),
        _buildSummaryRow(
            'التاريخ', c.selectedDate.value?.toString().split(' ')[0] ?? ''),
        const Divider(),
  if(c.notesController.text.trim() .isNotEmpty)      _buildSummaryRow(
            'ملاحظات', '${formatValue(c.notesController.text)}'),
        if (c.errorMessage.value.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(8)),
            child: Text(c.errorMessage.value,
                style: const TextStyle(color: Colors.red)),
          )
        ]
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildMeasureInputStep({
    required BuildContext context,
    required AddWeekProgressController controller,
    required String title,
    required String label,
    required TextEditingController textController,
    required String description,
  }) {
    if (textController.text.isEmpty) {
      if (title.contains('وزنك')) {
        textController.text = '70.00';
      } else if (title.contains('الوسط')) {
        textController.text = '80.00';
      } else {
        textController.text = '40.00';
      }
    }

    final double currentValue = double.tryParse(textController.text) ?? 70.0;

    int minValue = 10;
    int maxValue = 200;

    if (title.contains('وزنك')) {
      minValue = 30;
      maxValue = 250;
    } else if (title.contains('الوسط')) {
      minValue = 40;
      maxValue = 180;
    } else if (title.contains('الحوض')) {
      minValue = 40;
      maxValue = 200;
    } else if (title.contains('الذراع')) {
      minValue = 10;
      maxValue = 100;
    }

    double stepValue = 0.1;
    int decimalPlaces = 1;

    if (title.contains('وزنك')) {
      stepValue = 0.05;
      decimalPlaces = 2;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 32),
        Text(title,
            style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 48),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              double.tryParse(textController.text)
                      ?.toStringAsFixed(decimalPlaces) ??
                  currentValue.toStringAsFixed(decimalPlaces),
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 77),
            ),
            const SizedBox(width: 4),
            Text(
              label.contains('كجم') ? 'كجم' : 'سم',
              style: const TextStyle(
                  fontSize: 24,
                  color: CustomColors.mainColor,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 170,
          child: _buildDualColumnPicker(
            context: context,
            currentValue: currentValue,
            minValue: minValue,
            maxValue: maxValue,
            stepValue: stepValue,
            decimalPlaces: decimalPlaces,
            onChanged: (value) {
              textController.text = value.toStringAsFixed(decimalPlaces);
              controller.update();
            },
          ),
        ),
        const SizedBox(height: 48),
        Text(
          description,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayMedium,
        ),
        if (controller.errorMessage.value.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Text(controller.errorMessage.value,
                style: const TextStyle(color: Colors.red)),
          )
      ],
    );
  }

  Widget _buildSuccessStep(BuildContext context, AddWeekProgressController c) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle, size: 80, color: CustomColors.mintGold),
        const SizedBox(height: 24),
        const Text('تم الإرسال بنجاح',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Text(c.successMessage.value,
            style: const TextStyle(color: Colors.grey, fontSize: 16)),
        const SizedBox(height: 48),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.mainColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child:  Text('العودة',
                style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.white)),
          ),
        )
      ],
    );
  }

  Widget _buildBottomControls(
      BuildContext context, AddWeekProgressController c) {
    bool isLastStep = c.currentStep.value == c.totalSteps.value - 1;

    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: c.isLoading.value ? null : c.nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.mainColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: c.isLoading.value
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : Text(
                      isLastStep ? 'إرسال' : 'استمرار',
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.white) ,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDualColumnPicker({
    required BuildContext context,
    required double currentValue,
    required int minValue,
    required int maxValue,
    required Function(double) onChanged,
    double stepValue = 0.05,
    int decimalPlaces = 2,
  }) {
    int integerPart = currentValue.floor();
    int ticks = (1.0 / stepValue).round();
    int decimalPart = ((currentValue - integerPart) / stepValue).round();

    // Clamp decimalPart just in case of float arithmetic edge cases
    if (decimalPart < 0) decimalPart = 0;
    if (decimalPart >= ticks) decimalPart = ticks - 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NumberPicker(
          key: const ValueKey('decimal'),
          value: decimalPart,
          minValue: 0,
          maxValue: ticks - 1,
          step: 1,
          selectedTextStyle: const TextStyle(
              color: CustomColors.mainColor,
              fontSize: 32,
              fontWeight: FontWeight.bold),
          textStyle: const TextStyle(color: Colors.grey, fontSize: 18),
          itemHeight: 50,
          itemWidth: 60,
          textMapper: (value) {
            int val = int.parse(value);
            double decimal = val * stepValue;
            String str = decimal.toStringAsFixed(decimalPlaces);
            return str.contains('.') ? str.split('.')[1] : str;
          },
          onChanged: (value) {
            double newValue = integerPart + (value * stepValue);
            onChanged(newValue);
          },
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('.',
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.mainColor)),
        ),
        NumberPicker(
          key: const ValueKey('integer'),
          value: integerPart,
          minValue: minValue,
          maxValue: maxValue,
          step: 1,
          selectedTextStyle: const TextStyle(
              color: CustomColors.mainColor,
              fontSize: 32,
              fontWeight: FontWeight.bold),
          textStyle: const TextStyle(color: Colors.grey, fontSize: 18),
          itemHeight: 50,
          itemWidth: 60,
          onChanged: (value) {
            double newValue = value + (decimalPart * stepValue);
            onChanged(newValue);
          },
        ),
      ],
    );
  }
}
