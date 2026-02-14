import 'package:diet_picnic_client/components/custom_dropdown_widget.dart';
import 'package:diet_picnic_client/components/custom_text_form_field.dart';
import 'package:diet_picnic_client/controller/update_personal_info_controller.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/core/is_valid_phone.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class UpdatePersonalInfoView extends StatelessWidget {
  const UpdatePersonalInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdatePersonalInfoController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "تحديث معلوماتي الشخصية",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        centerTitle: true,
      ),
      body: Obx(
            () => Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(key:controller.formKey ,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ====== Name ======
                  CustomTextFormField(
                    context: context,
                    label: "اسم المستخدم",

                    controller: controller.nameController,
                    validator: (v) {
                      if ( controller.nameController.text.trim().isEmpty) {
                        return "من فضلك أدخل اسم المستخدم";
                      } else if (controller.nameController.text.trim().length < 3) {
                        return "يجب أن يحتوي الاسم على 3 أحرف على الأقل";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomTextFormField(
                    context: context,
                    label: "رقم الهاتف",

                    controller: controller.phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (v) {
                      if ( controller.phoneController.text.trim().isEmpty) {
                        return "من فضلك أدخل رقم الهاتف";
                      } else if (!isValidPhoneNumber(controller.phoneController.text.trim())) {
                        return "رقم الهاتف غير صالح";
                      }
                      return null;
                    },
                  ),
                  // ====== Email ======
                  CustomTextFormField(
                    context: context,
                    controller: controller.emailController,
                    label: "البريد الإلكتروني",
                  ),
                  const SizedBox(height: 12),

                  // ====== Qualification ======
                  CustomTextFormField(
                    context: context,
                    controller: controller.qualificationController,
                    label: "المؤهل",
                  ),
                  const SizedBox(height: 12),

                  CustomTextFormField(
                    context: context,
                    controller: controller.addressController,
                    label: "العنوان",
                  ),
                  const SizedBox(height: 12),

                  // ====== Social Status ======
                  CustomDropdownWidget(
                    label: "الحالة الاجتماعية",
                    selectedItem: controller.selectedSocialStatus.value,
                    items: controller.socialStatuses,
                    onChanged: controller.setSocialStatus,
                    dark: true,
                    color: CustomColors.textBlack54,
                  ),
                  const SizedBox(height: 12),

                  // ====== Height ======
                  CustomTextFormField(
                    context: context,
                    controller: controller.heightController,
                    label: "الطول (سم)",
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),

                  // ====== Gender ======
                  CustomDropdownWidget(
                    label: "النوع",
                    selectedItem: controller.selectedGender.value.isEmpty
                        ? null
                        : controller.selectedGender.value,
                    items: const ["ذكر", "أنثى"],
                    onChanged: controller.onSelectGender,
                    dark: true,
                    color: CustomColors.textBlack54,
                  ),

                  const SizedBox(height: 12),

                  // ====== Birthday ======
                  GestureDetector(
                    onTap: () => controller.pickBirthday(context),
                    child: AbsorbPointer(
                      child: CustomTextFormField(
                        context: context,
                        controller: TextEditingController(
                          text: controller.selectedBirthday.value == null
                              ? ''
                              : DateFormat('yyyy-MM-dd')
                              .format(controller.selectedBirthday.value!),
                        ),
                        label: "تاريخ الميلاد",
                        suffixIcon:  (Icons.calendar_today),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ====== Save Button ======
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.selectedNavBarColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.updatePersonalInfo,
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "حفظ التغييرات",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
