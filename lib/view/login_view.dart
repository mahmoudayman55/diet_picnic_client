import 'package:diet_picnic_client/components/custom_text_form_field.dart';
import 'package:diet_picnic_client/components/custom_url_luncher.dart';
import 'package:diet_picnic_client/controller/login_controller.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/core/is_valid_phone.dart';
import 'package:diet_picnic_client/view/navigator_view.dart';
import 'package:diet_picnic_client/view/register_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../components/animated_column.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: controller.formKey,
              child: AnimatedColumn(
                children: [
                  SizedBox(
                    width: width * 0.4,
                    height: width * 0.4,
                    child: Image.asset(AppConstants.appLogo),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "أهلا بيك في Diet Picnic",
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge!
                        .copyWith(color: CustomColors.mainColor),
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    context: context,
                    controller: controller.phoneController,
                    label: "رقم الهاتف",
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone,
                    validator: (v) {
                      if (controller.phoneController.text.trim().isEmpty) {
                        return "من فضلك أدخل رقم الهاتف";
                      }
                      // else if (!isValidPhoneNumber(controller.phoneController.text)) {
                      //   return "رقم الهاتف غير صالح";
                      // }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    context: context,
                    controller: controller.passwordController,
                    label: "كلمة المرور",
                    validator: (v) {
                      if (controller.passwordController.text.trim().isEmpty) {
                        return "من فضلك أدخل كلمة المرور";
                      }
                      return null;
                    },
                    obscureText: true,
                    prefixIcon: Iconsax.lock_1,
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.login(),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "تسجيل دخول",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(color: Colors.white),
                              ),
                      ),
                    );
                  }),
                  TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () {
                      Get.dialog(
                        AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          title:  Text(
                            "إعادة تعيين كلمة المرور",
                            textAlign: TextAlign.center,style: Theme.of(context).textTheme.displayLarge,
                          ),
                          content: Text(
                            "لإعادة تعيين كلمة المرور، يرجى التواصل مع فريق الدعم على واتساب.",
                            style: Theme.of(context).textTheme.displayMedium,
                            textAlign: TextAlign.center,
                          ),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    CustomColors.selectedNavBarColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () async {
                                CustomUrlLauncher.launchWhatsApp(
                                  phoneNumber: AppConstants.phoneNumber,
                                  message:
                                      "مرحبًا 👋\nأواجه مشكلة في تسجيل الدخول وأرغب في إعادة تعيين كلمة المرور لحسابي على *Diet Picnic* 🥗.\n\nهل يمكنكم مساعدتي؟ 🙏",
                                );
                              },
                              icon: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: const Icon(Icons.message_outlined,
                                    color: Colors.white),
                              ),
                              label: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  "تواصل عبر واتساب",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Get.back(),
                              child: Text(
                                "إغلاق",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text(
                      'نسيت كلمة المرور',
                      style:
                          Theme.of(context).textTheme.displayMedium!.copyWith(
                                color: CustomColors.mainColor,
                              ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ليس لديك حساب؟ ',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () => Get.toNamed(AppConstants.registerPage),
                        child: Text(
                          'إنشاء حساب',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(color: CustomColors.mainColor),
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
