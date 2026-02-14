import 'package:diet_picnic_client/components/custom_app_bar.dart';
import 'package:diet_picnic_client/components/custom_text_form_field.dart';
import 'package:diet_picnic_client/controller/change_password_controller.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../components/animated_column.dart';

class ChangePasswordView extends StatelessWidget {
  ChangePasswordView({super.key});

  final controller = Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(appBar: CustomAppBar(title: "تغيير كلمة المرور"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: AnimatedColumn(
              children: [
                // App logo
                // SizedBox(
                //   width: width * 0.35,
                //   height: width * 0.35,
                //   child: Image.asset(AppConstants.appLogo),
                // ),
                // const SizedBox(height: 16),
                //
                // Text(
                //   "تغيير كلمة المرور",
                //   style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                //     color: CustomColors.mainColor,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                //
                // const SizedBox(height: 32),

                // Old password
                CustomTextFormField(
                  context: context,
                  label: "كلمة المرور الحالية",
                  prefixIcon: Iconsax.lock,
                  controller: controller.oldPasswordController,
                  obscureText: true,
                ),
                const SizedBox(height: 16),

                // New password
                CustomTextFormField(
                  context: context,
                  label: "كلمة المرور الجديدة",
                  prefixIcon: Iconsax.lock_1,
                  controller: controller.newPasswordController,
                  obscureText: true,
                ),
                const SizedBox(height: 16),

                // Confirm new password
                CustomTextFormField(
                  context: context,
                  label: "تأكيد كلمة المرور الجديدة",
                  prefixIcon: Iconsax.lock,
                  controller: controller.confirmPasswordController,
                  obscureText: true,
                ),
                const SizedBox(height: 24),

                // Submit button
                Obx(() {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : controller.changePassword,
                      child: controller.isLoading.value
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                          : const Text("تأكيد التغيير"),
                    ),
                  );
                }),

                const SizedBox(height: 12),

                // Back to profile button
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    "رجوع",
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: CustomColors.mainColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
