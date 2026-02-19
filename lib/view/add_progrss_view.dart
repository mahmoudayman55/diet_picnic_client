import 'package:diet_picnic_client/components/custom_text_form_field.dart';
import 'package:diet_picnic_client/components/date_picker_chip_widget.dart';
import 'package:diet_picnic_client/controller/add_week_progress_controller.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddWeekProgressView extends StatelessWidget {
  const AddWeekProgressView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Avoid duplicate instance creation
    final controller = Get.put(AddWeekProgressController());

    final isEditing = controller.initialModel != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'تعديل التقدم الأسبوعي' : 'إضافة تقدم أسبوعي',style: Theme.of(context).textTheme.displayLarge,),
        foregroundColor: Colors.white,
      ),
      // backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.formKey,
          child: GetBuilder<AddWeekProgressController>(
            builder: (c) {
              return ListView(
                children: [
                  CustomTextFormField(
                    context: context,
                    label: 'الوزن',
                    controller: controller.weightController,autoValidate: false,
                    keyboardType: TextInputType.number,enabled: controller.excuseController.text.isEmpty,
                    validator: (val) => controller.validateNumber(controller.weightController.text, 'الوزن'),
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    context: context,
                    label: 'مقاس الوسط',
                    controller: controller.waistController,autoValidate: false,
                    keyboardType: TextInputType.number,enabled: controller.excuseController.text.isEmpty,
                    validator: (val) => controller.validateNumber(controller.waistController.text, 'مقاس الوسط'),
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    context: context,
                    label: 'مقاس الحوض',
                    controller: controller.pelvisController,autoValidate: false,
                    keyboardType: TextInputType.number,enabled: controller.excuseController.text.isEmpty,
                    validator: (val) => controller.validateNumber(controller.pelvisController.text, 'مقاس الحوض'),
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    context: context,
                    label: 'مقاس وسط الذراع',
                    controller: controller.rightArmController,
                    keyboardType: TextInputType.number,enabled: controller.excuseController.text.isEmpty,autoValidate: false,
                    validator: (val) => controller.validateNumber(controller.rightArmController.text, 'مقاس وسط الذراع'),
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    context: context,onChanged: (v){
                    controller.rightArmController.clear();
                    controller.pelvisController.clear();
                    controller.waistController.clear();
                    controller.weightController.clear();
                    c.update();
                  },
                    isRequired: false,
                    label: "عذر",
                    controller: controller.excuseController,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    context: context,
                    isRequired: false,
                    label: 'ملاحظات',
                    maxLines: 5,
                    controller: controller.notesController,
                  ),
                  const SizedBox(height: 16),
                  Obx(() => DatePickerChip(
                    value: controller.selectedDate.value,
                    placeholder: 'التاريخ',
                    onDateSelected: controller.setDate,
                  )),
                  const SizedBox(height: 24),
                  Obx(() => controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                    onPressed: controller.saveProgress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.selectedNavBarColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isEditing ? 'تحديث التقدم' : 'إضافة التقدم',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  )),
                  const SizedBox(height: 16),

                  // Error message
                  Obx(() => controller.errorMessage.value.isNotEmpty
                      ? Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.white),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.errorMessage.value,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )
                      : const SizedBox.shrink()),

                  // Success message
                  Obx(() => controller.successMessage.value.isNotEmpty
                      ? Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CustomColors.mintGold,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            controller.successMessage.value,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  )
                      : const SizedBox.shrink()),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
