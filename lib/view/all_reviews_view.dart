import 'package:diet_picnic_client/components/book_widget.dart';
import 'package:diet_picnic_client/components/custom_app_bar.dart';
import 'package:diet_picnic_client/components/logo_loading_widget.dart';
import 'package:diet_picnic_client/components/review_widget.dart';
import 'package:diet_picnic_client/controller/all_reviews_controller.dart';
import 'package:diet_picnic_client/controller/books_controller.dart';
import 'package:diet_picnic_client/view/animated_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

class AllReviewsView extends GetView<AllReviewsController> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      final width = 100.w;
      final heigh = 100.h;
      bool isMobile = deviceType == DeviceType.mobile;
      return Scaffold(
        appBar: CustomAppBar(title: "آراء العملاء"),
        body: Obx(
          () => Padding(
            padding: const EdgeInsets.all(16),
            child: controller.isLoadingReviews.value
                ? const LogoLoadingWidget()
                : SizedBox(height: heigh,
                  child: ListView.builder(
                      itemCount: controller.reviews.length,
                      itemBuilder: (c, i) => SizedBox(width: width,
                        child: ReviewWidget(
                          review: controller.reviews[i],
                          maxLines: 100,
                        ),
                      ),
                    ),
                ),
          ),
        ),
      );
    });
  }
}
