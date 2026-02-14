import 'package:diet_picnic_client/components/animated_column.dart';
import 'package:diet_picnic_client/components/custom_app_bar.dart';
import 'package:diet_picnic_client/components/custom_text_form_field.dart';
import 'package:diet_picnic_client/controller/register_controller.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/core/is_valid_phone.dart';
import 'package:diet_picnic_client/view/login_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

/// 🟢 View
class RegisterView extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Form(key: controller.formKey,
              child: Column(
                children: [
                  Image.asset(AppConstants.appLogo, height: 120),
                  const SizedBox(height: 16),
                  Text(
                    "أهلا بيك في Diet Picnic",
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(color: CustomColors.mainColor),
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    context: context,
                    label: "اسم المستخدم",
                    prefixIcon: Iconsax.user,
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

                  const SizedBox(height: 16),

                  CustomTextFormField(
                    context: context,
                    label: "رقم الهاتف",
                    prefixIcon: Icons.phone,
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

                  const SizedBox(height: 16),

                  CustomTextFormField(
                    context: context,
                    label: "كلمة المرور",
                    prefixIcon: Iconsax.lock_1,
                    controller: controller.passwordController,
                    obscureText: true,
                    validator: (v) {
                      if ( controller.passwordController.text.trim().isEmpty) {
                        return "من فضلك أدخل كلمة المرور";
                      } else if (controller.passwordController.text.trim().length < 6) {
                        return "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  CustomTextFormField(
                    context: context,
                    label: "تأكيد كلمة المرور",
                    prefixIcon: Iconsax.lock_1,
                    controller: controller.confirmPasswordController,
                    obscureText: true,
                    validator: (v) {
                      if ( controller.confirmPasswordController.text.trim().isEmpty) {
                        return "من فضلك أدخل تأكيد كلمة المرور";
                      } else if (controller.confirmPasswordController.text.trim() !=
                          controller.passwordController.text.trim()) {
                        return "كلمتا المرور غير متطابقتين";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Obx(() => ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.register,
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          :  Text("تسجيل",style: Theme.of(context).textTheme.displayLarge!.copyWith(color: Colors.white),),
                    )),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'لديك حساب بالفعل؟ ',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () {
                          Get.toNamed(AppConstants.loginPage);
                        },
                        child: Text(
                          ' تسجيل دخول',
                          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            color: CustomColors.mainColor,
                          ),
                        ),
                      ),
                    ],
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
