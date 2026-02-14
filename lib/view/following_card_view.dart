import 'package:diet_picnic_client/components/animated_column.dart';
import 'package:diet_picnic_client/components/custom_app_bar.dart';
import 'package:diet_picnic_client/components/following_card_widget.dart';
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

class FollowingCardView extends StatelessWidget {
  const FollowingCardView({
    super.key,
  }); // باراميتر اختياري

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      final width = 100.w;
      final heigh = 100.h;
      bool isMobile = deviceType == DeviceType.mobile;

      return Scaffold(
        appBar: CustomAppBar(title: "كارت المتابعة"),
        // يتحكم في ظهور الـ AppBar
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: GetBuilder<UserController>(builder: (c) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (UserController.to.isLoggedIn)
                  Text(
                    "كارت المتابعة هيساعدك تشوف تطورك من أول متابعة لحد دلوقتي مع Diet Picnic 💪",
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(color: CustomColors.selectedNavBarColor),
                    textAlign: TextAlign.center,
                  ),
                buildCompareProgressWidget(
                    context,
                    UserController.to.currentUser.value!.getFirstFollowing(),
                    UserController.to.currentUser.value!.getLastFollowing()),
              ],
            );
          }),
        ),
      );
    });
  }
}
