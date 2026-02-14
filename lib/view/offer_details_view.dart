import 'dart:ui';

import 'package:diet_picnic_client/components/animated_column.dart';
import 'package:diet_picnic_client/components/custom_app_bar.dart';
import 'package:diet_picnic_client/components/offer_price_widget.dart';
import 'package:diet_picnic_client/controller/offer_details_controller.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

class OfferDetailsView extends GetView<OfferDetailsController> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      final width = 100.w;
      final heigh = 100.h;
      bool isMobile = deviceType == DeviceType.mobile;
      return Scaffold(
        appBar: CustomAppBar(title: "عروض باقة النحافة"),
        body: SizedBox(
          height: heigh,
          child: Column(
            children: [
              // الصور
              Expanded(
                flex: 22,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PageView.builder(
                      controller: controller.pageController,
                      itemCount: controller.images.length,
                      onPageChanged: controller.onPageChanged,
                      itemBuilder: (context, index) {
                        return Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: double.maxFinite,
                              child: ImageFiltered(
                                imageFilter:
                                    ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                                child: Image.network(
                                  controller.images[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            Image.network(
                              controller.images[index],
                              fit: BoxFit.contain,
                              width: double.infinity,
                            ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.transparent,
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.3),
                                      Colors.black.withOpacity(0.8),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 50,
                                child: AnimatedColumn(
                                  children: [
                                    Text(
                                      "VIP",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge!
                                          .copyWith(color: Colors.white),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "عرض الصيف 3شهور + شهر هدية",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(color: Colors.white),
                                    ),
                                    const SizedBox(height: 8),
                                    OfferPriceWidget(
                                      oldPrice: 500,
                                      offerPrice: 250,
                                      oldPriceColor: Colors.white,
                                      offerPriceColor: CustomColors.mainColor,
                                    ),
                                  ],
                                ))
                          ],
                        );
                      },
                    ),

                    // المؤشر
                    Positioned(
                      bottom: 25,
                      child: Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              List.generate(controller.images.length, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: controller.currentIndex.value == index
                                  ? 16
                                  : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: controller.currentIndex.value == index
                                    ? CustomColors.mainColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // زر الاشتراك
              Expanded(
                flex: 2,
                child: SizedBox(
                  width: width,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.selectedNavBarColor,
                      shape: BeveledRectangleBorder(),
                    ),
                    onPressed: controller.onSubscribe,
                    child: Text(
                      "اشترك الآن",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
