import 'package:diet_picnic_client/components/animated_column.dart';
import 'package:diet_picnic_client/components/custom_app_bar.dart';
import 'package:diet_picnic_client/components/progress_section.dart';
import 'package:diet_picnic_client/controller/user_controller.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/models/client_profile_model.dart';
import 'package:diet_picnic_client/view/add_progrss_view.dart';
import 'package:diet_picnic_client/view/weekly_progress_chart_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

class ProgressView extends StatelessWidget {
  final bool showAppBar;

  const ProgressView({super.key, this.showAppBar = true}); // باراميتر اختياري

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      final width = 100.w;
      final heigh = 100.h;
      bool isMobile = deviceType == DeviceType.mobile;

      return Scaffold(
        appBar: showAppBar
            ? CustomAppBar(title: "التقدم الأسبوعى")
            : null, // يتحكم في ظهور الـ AppBar
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: GetBuilder<UserController>(builder: (c) {
            return Column(
              children: [
                Expanded(
                  flex: 18,
                  child: SingleChildScrollView(
                    child: AnimatedColumn(
                      children: [
                        ProgressSection(
                            client: UserController.to.currentUser!.value!),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed:
                          UserController
                                  .to.currentUser.value!.weeklyFollowUpSent
                              ? null
                              :
                              () {
                                  Get.to(AddWeekProgressView());
                                },
                          icon: Icon(
                            UserController
                                    .to.currentUser.value!.weeklyFollowUpSent
                                ? Icons.done
                                : Icons.add,
                            color: Colors.white,
                          ),
                          label: Text(
                            !UserController.to.isSubscriptionActive
                                ? "يرجى تجديد الإشتراك"
                                : UserController.to.currentUser.value!
                                        .weeklyFollowUpSent
                                    ? "تم الإرسال"
                                    :
                            'إضافة تقدم أسبوعي',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: UserController
                                    .to.currentUser.value!.weeklyFollowUpSent
                                ? Colors.lightGreen
                                : CustomColors.mainColor,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor:
                                !UserController.to.isSubscriptionActive
                                    ? Colors.grey
                                    : Colors.lightGreen.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Get.to(() => WeeklyProgressChartView(
                                  weekProgressList: UserController
                                      .to.currentUser!.value!.weekProgressList,
                                ));
                          },
                          icon: const Icon(Icons.trending_up),
                          label: Text(
                            'عرض مخطط التقدم',
                            textAlign: TextAlign.center,
                          ),
                          style: ElevatedButton.styleFrom(
                            textStyle: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color: CustomColors.selectedNavBarColor),
                            foregroundColor: CustomColors.selectedNavBarColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(
                                color: CustomColors.selectedNavBarColor),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }),
        ),
      );
    });
  }
}
