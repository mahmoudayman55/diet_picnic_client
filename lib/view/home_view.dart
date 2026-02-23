import 'package:diet_picnic_client/components/animated_column.dart';
import 'package:diet_picnic_client/components/bmi_section.dart';
import 'package:diet_picnic_client/components/book_widget.dart';
import 'package:diet_picnic_client/components/custom_app_bar.dart';
import 'package:diet_picnic_client/components/informationTRWidget.dart';
import 'package:diet_picnic_client/components/loading_widget.dart';
import 'package:diet_picnic_client/components/logo_loading_widget.dart';
import 'package:diet_picnic_client/components/lotti_widget.dart';
import 'package:diet_picnic_client/components/offer_widget.dart';
import 'package:diet_picnic_client/components/offers_slider.dart';
import 'package:diet_picnic_client/components/reading_section.dart';
import 'package:diet_picnic_client/components/review_slider.dart';
import 'package:diet_picnic_client/components/review_widget.dart';
import 'package:diet_picnic_client/components/section_widget.dart';
import 'package:diet_picnic_client/components/package_widget.dart';
import 'package:diet_picnic_client/components/visual_section.dart';
import 'package:diet_picnic_client/components/welcome_card.dart';
import 'package:diet_picnic_client/controller/home_controller.dart';
import 'package:diet_picnic_client/controller/user_controller.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/core/theme.dart';
import 'package:diet_picnic_client/view/add_progrss_view.dart';
import 'package:diet_picnic_client/view/progress_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      final width = 100.w;
      final heigh = 100.h;
      bool isMobile = deviceType == DeviceType.mobile;
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: width,
            child: RefreshIndicator(
              onRefresh: () async {
                controller.onInit();
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (UserController.to.isLoggedIn &&
                        UserController.to.isSubscribed &&
                        UserController.to.isSubscriptionActive &&
                        !UserController.to.currentUser.value!.weeklyFollowUpSent)
                      InkWell(
                        onTap: () => Get.to(AddWeekProgressView()),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(width * 0.04),

                          // اللون المؤثر على كل الودجت (الخلفية)
                          decoration: BoxDecoration(
                            color: DateTime.now().weekday == DateTime.thursday
                                ? Colors.red.shade50
                                : DateTime.now().weekday == DateTime.wednesday
                                    ? Colors.orange.shade50
                                    : Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // أيقونة بلون حسب اليوم
                                  Container(
                                    padding: EdgeInsets.all(width * 0.02),
                                    decoration: BoxDecoration(
                                      color: DateTime.now().weekday ==
                                              DateTime.thursday
                                          ? Colors.red
                                          : DateTime.now().weekday ==
                                                  DateTime.wednesday
                                              ? Colors.orange
                                              : Colors.blue,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.notifications_none,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),

                                  SizedBox(width: width * 0.03),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // عنوان المتابعة
                                        Text(
                                          'المتابعة الأسبوعية',
                                          style: Themes
                                              .lightTheme.textTheme.displayLarge
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: DateTime.now().weekday ==
                                                    DateTime.thursday
                                                ? Colors.red.shade700
                                                : DateTime.now().weekday ==
                                                        DateTime.wednesday
                                                    ? Colors.orange.shade700
                                                    : Colors.blue.shade700,
                                          ),
                                        ),

                                        // الرسالة الديناميكية حسب اليوم
                                        Text(
                                          DateTime.now().weekday ==
                                                  DateTime.thursday
                                              ? "انهارده آخر فرصة — لازم تبعت المتابعة الأسبوعية اليوم"
                                              : DateTime.now().weekday ==
                                                      DateTime.wednesday
                                                  ? "فاضل يومين بس — يفضل تبعت المتابعة الأسبوعية قبل نهاية الأسبوع"
                                                  : "تذكير: لا تنسَ إرسال المتابعة الأسبوعية قبل نهاية الأسبوع",
                                          style: Themes
                                              .lightTheme.textTheme.displaySmall
                                              ?.copyWith(
                                            color: DateTime.now().weekday ==
                                                    DateTime.thursday
                                                ? Colors.red.shade600
                                                : DateTime.now().weekday ==
                                                        DateTime.wednesday
                                                    ? Colors.orange.shade600
                                                    : Colors.blue.shade600,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                    WelcomeCard(),
                    SizedBox(
                      height: heigh * 0.03,
                    ),

                    Obx(
                      () => controller.offers.isNotEmpty
                          ? Text(
                              "العروض",
                              style: Theme.of(context).textTheme.headlineSmall,
                            )
                          : SizedBox.shrink(),
                    ),
                    // SingleChildScrollView(scrollDirection: Axis.horizontal,
                    //   child: Row(
                    //     children: [
                    //       SizedBox(width: width*0.7,height: heigh*0.6,child: ServiceWidget()),
                    //       SizedBox(width: width*0.7,height: heigh*0.6,child: ServiceWidget()),
                    //       SizedBox(width: width*0.7,height: heigh*0.6,child: ServiceWidget()),
                    //       SizedBox(width: width*0.7,height: heigh*0.6,child: ServiceWidget()),
                    //     ],
                    //   ),
                    // )
                    Obx(() => controller.isLoadingOffers.value
                        ? LogoLoadingWidget()
                        : OffersSlider(
                            width: width,
                            height: heigh,
                            offers: controller.offers.value)),
                    SizedBox(
                      height: heigh * 0.03,
                    ),
                    Text(
                      "الباقات",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Obx(
                      () => controller.isLoadingPackages.value
                          ? LogoLoadingWidget()
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.zero,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: controller.packages.value
                                      .map(
                                        (e) => SizedBox(
                                            width: width * 0.4,
                                            child: PackageWidget(e)),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: heigh * 0.025,
                    ),
                    BmiSection(),
                    SizedBox(
                      height: heigh * 0.025,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ReadingSection(),
                        VisualSection(),
                      ],
                    ),
                    SizedBox(
                      height: heigh * 0.025,
                    ),
                    KnowledgeSection(),

                    SizedBox(
                      height: heigh * 0.025,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "آراء العملاء",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        TextButton(
                            onPressed: () {
                              Get.toNamed(AppConstants.reviewsPage);
                            },
                            child: Text(
                              "عرض المزيد",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(color: CustomColors.mainColor),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: heigh * 0.24,
                      child: Obx(
                        () => controller.isLoadingReviews.value
                            ? LogoLoadingWidget()
                            : AutoSlidingReviewsList(
                                reviews: controller.reviews.value),
                      ),
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
