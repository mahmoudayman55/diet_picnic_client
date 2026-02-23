import 'package:diet_picnic_client/components/animated_column.dart';
import 'package:diet_picnic_client/components/bmi_section.dart';
import 'package:diet_picnic_client/components/book_widget.dart';
import 'package:diet_picnic_client/components/custom_app_bar.dart';
import 'package:diet_picnic_client/components/informationTRWidget.dart';
import 'package:diet_picnic_client/components/loading_widget.dart';
import 'package:diet_picnic_client/components/logo_loading_widget.dart';
import 'package:diet_picnic_client/components/lotti_widget.dart';
import 'package:diet_picnic_client/components/meeting_banner_widget.dart';
import 'package:diet_picnic_client/components/offer_widget.dart';
import 'package:diet_picnic_client/components/offers_slider.dart';
import 'package:diet_picnic_client/components/reading_section.dart';
import 'package:diet_picnic_client/components/review_slider.dart';
import 'package:diet_picnic_client/components/review_widget.dart';
import 'package:diet_picnic_client/components/section_widget.dart';
import 'package:diet_picnic_client/components/package_widget.dart';
import 'package:diet_picnic_client/components/visual_section.dart';
import 'package:diet_picnic_client/components/weekly_follow_up_card.dart';
import 'package:diet_picnic_client/components/welcome_card.dart';
import 'package:diet_picnic_client/controller/home_controller.dart';
import 'package:diet_picnic_client/controller/meetings_controller.dart';
import 'package:diet_picnic_client/controller/user_controller.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
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
                MeetingsController.to.onInit();
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (UserController.to.isLoggedIn &&
                        UserController.to.isSubscribed &&
                        UserController.to.isSubscriptionActive &&
                        !UserController
                            .to.currentUser.value!.weeklyFollowUpSent)
                      const WeeklyFollowUpCard(),

                    // Meeting banner — visible to everyone
                    Column(
                      children: [
                        SizedBox(height: heigh * 0.03),
                        const MeetingBannerWidget(),
                        SizedBox(
                          height: heigh * 0.03,
                        ),
                      ],
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
