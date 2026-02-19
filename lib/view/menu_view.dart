import 'dart:developer';

import 'package:diet_picnic_client/components/custom_cached_network_image.dart';
import 'package:diet_picnic_client/components/custom_snack_bar.dart';
import 'package:diet_picnic_client/components/custom_url_luncher.dart';
import 'package:diet_picnic_client/components/following_card_widget.dart';
import 'package:diet_picnic_client/components/menu_button_widget.dart';
import 'package:diet_picnic_client/components/section_widget.dart';
import 'package:diet_picnic_client/components/social_media_widget.dart';
import 'package:diet_picnic_client/controller/app_update_controller.dart';
import 'package:diet_picnic_client/controller/theme_controller.dart';
import 'package:diet_picnic_client/controller/user_controller.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/models/client_profile_model.dart';
import 'package:diet_picnic_client/models/package_model.dart';
import 'package:diet_picnic_client/view/about_view.dart';
import 'package:diet_picnic_client/view/client_package_details_view.dart';
import 'package:diet_picnic_client/view/following_card_view.dart';
import 'package:diet_picnic_client/view/package_details_view.dart';
import 'package:diet_picnic_client/view/progress_view.dart';
import 'package:diet_picnic_client/view/quiz_view.dart';
import 'package:diet_picnic_client/view/team_view.dart';
import 'package:diet_picnic_client/view/user_profile_view.dart';
import 'package:diet_picnic_client/view/water_reminder_view.dart';
import 'package:diet_picnic_client/view/body_composition_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      final width = 100.w;
      final heigh = 100.h;
      bool isMobile = deviceType == DeviceType.mobile;
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "الخيارات",
            style: Theme.of(context).textTheme.displayMedium,
          ),
          surfaceTintColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: width,
            height: heigh,
            child: SingleChildScrollView(
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (UserController.to.isLoggedIn)
                      SizedBox(
                        width: width,
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: CustomColors.shadowLight,
                                    blurRadius: 0,
                                    spreadRadius: 2)
                              ],
                              // color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Stack(
                            alignment: AlignmentGeometry.center,
                            children: [
                              Positioned(
                                  top: 0,
                                  child: SizedBox(width: width,height: heigh*0.2,
                                    child: Image.asset(
                                        "assets/images/lighter2.png",fit: BoxFit.fill,),
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: width * 0.3,
                                      height: width * 0.3,
                                      child: ClipOval(
                                        child: CustomCachedNetworkImage(
                                          imageUrl: UserController.to
                                                  .currentUser.value!.image ??
                                              AppConstants.dummyPerson1Image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: heigh * 0.03,
                                    ),
                                    Text(
                                      UserController.to.currentUser.value!.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w500),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        UserController.to
                                            .pickAndUploadProfileImage();
                                      },
                                      child: Text(
                                        "تغيير الصورة الشخصية",
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.w400,
                                                color: CustomColors.mainColor),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(
                      height: heigh * 0.03,
                    ),
                    if (UserController.to.isLoggedIn)
                      SectionWidget(
                          title: "حسابى",
                          // color: Color(0xFFFAFAFB),
                          elevation: 0,
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(UserProfileView());
                              },
                              child: MenuButtonWidget(
                                  leadingIcon: Iconsax.user,
                                  title: "المعلومات الشخصية"),
                            ),
                            InkWell(
                              onTap: () {
                                UserController.to.isSubscribed
                                    ? Get.to(ClientPackageDetailsView())
                                    : customSnackBar(
                                        title: "تنبيه",
                                        message: "انت غير مشترك في أي باقة",
                                        successful: false,
                                      );
                              },
                              child: MenuButtonWidget(
                                  leadingIcon: Icons.dashboard_outlined,
                                  title: "معلومات الباقة"),
                            ),
                            InkWell(
                              onTap: () {
                                if (!UserController.to.isSubscriptionActive) {
                                  customSnackBar(
                                    title: "تنبيه",
                                    message:
                                        "اشتراكك منتهي، جدد الاشتراك للاستمرار",
                                    successful: false,
                                  );
                                  return;
                                }
                                // if (!UserController.to.currentUser.value!
                                //     .hasActiveDiet()) {
                                //   customSnackBar(
                                //     title: "تنبيه",
                                //     message:
                                //         "لم يتم تعيين نظام غذائى حتى الأن.",
                                //     successful: false,
                                //   );
                                //   return;
                                // }

                                Get.toNamed(AppConstants.dietPage,
                                    arguments: true);
                              },
                              child: MenuButtonWidget(
                                  leadingIcon: Icons.fastfood_outlined,
                                  title: "نظامي الغذائى"),
                            ),
                            InkWell(
                              child: MenuButtonWidget(
                                  leadingIcon: Icons.sports_outlined,
                                  onTap: () {
                                    if (!UserController
                                        .to.isSubscriptionActive) {
                                      customSnackBar(
                                        title: "تنبيه",
                                        message:
                                            "اشتراكك منتهي، جدد الاشتراك للاستمرار",
                                        successful: false,
                                      );
                                      return;
                                    }
                                    if (!UserController.to.currentUser.value!
                                        .hasActiveExercise()) {
                                      customSnackBar(
                                        title: "تنبيه",
                                        message:
                                            "لم يتم تعيين نظام رياضى حتى الأن.",
                                        successful: false,
                                      );
                                      return;
                                    }
                                    Get.toNamed(
                                        AppConstants.exerciseSystemsPage,
                                        arguments: true);
                                  },
                                  title: "نظامي الرياضي"),
                            ),
                            InkWell(
                              onTap: () {
                                UserController.to.isSubscribed
                                    ? Get.to(ProgressView())
                                    : customSnackBar(
                                        title: "تنبيه",
                                        message: "انت غير مشترك في أي باقة",
                                        successful: false,
                                      );
                              },
                              child: MenuButtonWidget(
                                  leadingIcon: Icons.trending_up,
                                  title: "تقدمى"),
                            ),
                            InkWell(
                              onTap: () {
                                final userController = UserController.to;

                                final isSubscribed =
                                    userController.isSubscribed;

                                final hasEnoughFoloowings = userController
                                        .currentUser.value!.weekProgressList
                                        .where((f) => f.excuse.isEmpty)
                                        .length >=
                                    2;

                                if (!isSubscribed) {
                                  customSnackBar(
                                    title: "تنبيه",
                                    message: "انت غير مشترك في أي باقة",
                                    successful: false,
                                  );
                                  return;
                                }

                                if (!hasEnoughFoloowings) {
                                  customSnackBar(
                                    title: "تنبيه",
                                    message:
                                        "يجب ان يحتوي سجلك علي متابعتين اسبوعيتين علي الأقل",
                                    successful: false,
                                  );
                                  return;
                                }

                                Get.to(FollowingCardView());
                              },
                              child: MenuButtonWidget(
                                leadingIcon: Icons.task_outlined,
                                title: "كارت المتابعة",
                              ),
                            ),
                            InkWell(
                              onTap: () =>
                                  Get.toNamed(AppConstants.changePasswordPage),
                              child: MenuButtonWidget(
                                  leadingIcon: Iconsax.key,
                                  title: "تغيير كلمة المرور"),
                            ),
                            if (UserController.to.isLoggedIn)
                              InkWell(
                                onTap: () => UserController.to.logout(),
                                child: MenuButtonWidget(
                                    leadingIcon: Icons.logout,
                                    title: "تسجيل خروج"),
                              ),
                          ]),
                    SizedBox(
                      height: heigh * 0.03,
                    ),
                    SectionWidget(
                        title: "عام",
                        color: Color(0xFFFAFAFB),
                        elevation: 0,
                        children: [
                          if (!UserController.to.isLoggedIn)
                            InkWell(
                              onTap: () => Get.toNamed(AppConstants.loginPage),
                              child: MenuButtonWidget(
                                  leadingIcon: Icons.login_outlined,
                                  title: "تسجيل دخول"),
                            ),
                          if (!UserController.to.isLoggedIn)
                            if (!UserController.to.isLoggedIn)
                              InkWell(
                                onTap: () =>
                                    Get.toNamed(AppConstants.registerPage),
                                child: MenuButtonWidget(
                                    leadingIcon:
                                        Icons.app_registration_outlined,
                                    title: "إنشاء حساب"),
                              ),
                          // Theme Toggle
                          Obx(() => InkWell(
                                onTap: () {
                                  ThemeController.to.toggleTheme();
                                },
                                child: MenuButtonWidget(
                                  leadingIcon: ThemeController.to.isDarkMode
                                      ? Icons.dark_mode
                                      : Icons.light_mode,
                                  title: ThemeController.to.isDarkMode
                                      ? "الوضع الداكن"
                                      : "الوضع الفاتح",
                                  sideWidget: Switch(
                                    value: ThemeController.to.isDarkMode,
                                    onChanged: (value) {
                                      ThemeController.to.toggleTheme();
                                    },
                                    activeColor: CustomColors.mainColor,
                                  ),
                                ),
                              )),
                          InkWell(
                            onTap: () =>
                                Get.toNamed(AppConstants.waterReminderPage),
                            child: MenuButtonWidget(
                                leadingIcon: Icons.water_drop,
                                title: "تذكيرات شرب الماء"),
                          ),
                          InkWell(
                            onTap: () => Get.to(TeamworkScreen()),
                            child: MenuButtonWidget(
                                leadingIcon: Iconsax.people,
                                title: "فريق العمل"),
                          ),
                          InkWell(
                            onTap: () async {
                              if (!await launchUrl(
                                Uri.tryParse(AppConstants.privacyURL)!,
                                mode: LaunchMode
                                    .externalApplication, // Opens in the default browser (Chrome/Safari)
                              )) {
                                // Optional: Handle the case where the URL couldn't be opened
                                // ignore: avoid_print
                              }
                            },
                            child: MenuButtonWidget(
                                leadingIcon: Icons.privacy_tip_outlined,
                                title: "البيانات وسياسة الخصوصية"),
                          ),

                          InkWell(
                            onTap: () => Get.to(AboutView()),
                            child: MenuButtonWidget(
                              leadingIcon: Iconsax.info_circle,
                              title: "عن Diet Picnic",
                              sideWidget: Text(
                                "Version ${AppUpdateController.to.appVersion}",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                        ]),
                    SizedBox(
                      height: heigh * 0.03,
                    ),
                    SocialMediaSection(),
                    Text(
                      "All rights reserved © Diet Picnic",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: CustomColors.textBlack54),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
