import 'dart:ui';

import 'package:diet_picnic_client/components/custom_app_bar.dart';
import 'package:diet_picnic_client/components/custom_cached_network_image.dart';
import 'package:diet_picnic_client/components/labled_image_widget.dart';
import 'package:diet_picnic_client/components/logo_loading_widget.dart';
import 'package:diet_picnic_client/components/package_offer_widget.dart';
import 'package:diet_picnic_client/components/package_offer_widget.dart';
import 'package:diet_picnic_client/components/package_offer_widget.dart';
import 'package:diet_picnic_client/components/package_offer_widget.dart';
import 'package:diet_picnic_client/components/package_widget.dart';
import 'package:diet_picnic_client/components/read_more_widget.dart';
import 'package:diet_picnic_client/controller/package_details_controller.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/models/package_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

class PackageDetailsView extends GetView<PackageDetailsController> {
  PackageDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      final width = 100.w;
      final heigh = 100.h;
      bool isMobile = deviceType == DeviceType.mobile;
      return Obx(
        () => Scaffold(
          appBar: CustomAppBar(
              title: controller.package.value == null
                  ? ""
                  : controller.package.value!.name),
          body: SingleChildScrollView(
            child: Column(
              children: [
                controller.isLoading.value
                    ? SizedBox(height: heigh,child: Center(child: LogoLoadingWidget()))
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// صورة الهيدر

                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // الصورة الخلفية (كبيرة ومبكسلة بالبلور)
                            // AspectRatio(
                            //   aspectRatio: 9 / 12,
                            //   child: ImageFiltered(
                            //     imageFilter: ImageFilter.blur(
                            //         sigmaX: 8, sigmaY: 8), // درجة البلور
                            //     child: Image.network(
                            //       controller.package.value!.baseImage,
                            //       width: 100.w,
                            //       height: 28.h,
                            //       fit: BoxFit.cover,
                            //     ),
                            //   ),
                            // ),

                            // الصورة الأمامية (أصغر ومتمركزة)
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Container(
                                // margin: EdgeInsets.symmetric(
                                //     horizontal: 40, vertical: 60),
                                // تخليها أصغر
                                // decoration: BoxDecoration(
                                //
                                //   boxShadow: [
                                //     BoxShadow(
                                //       color: Colors.black.withOpacity(0.2),
                                //       blurRadius: 10,
                                //       offset: const Offset(0, 5),
                                //     ),
                                //   ],
                                // ),
                                child: ClipRRect(

                                  child: CustomCachedNetworkImage(
                                imageUrl:     controller.package.value!.coverImage.isEmpty?controller.package.value!.baseImage:controller.package.value!.coverImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: heigh * 0.02,
                        ),
                        // /// الاسم
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 16),
                        //   child: Text(
                        //     package.name,
                        //     style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.black87,
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: 8),

                        /// الوصف
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "تفاصيل الباقة",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge,
                                  ),
                                  SizedBox(
                                    height: heigh * 0.03,
                                  ),
                                  ReadMoreTextWidget(
                                    text: controller
                                        .package.value!.description,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        /// المميزات (SubTopics)
                        if (controller.package.value!.vipImage != null ||
                            controller.package.value!.eliteImage != null ||
                            controller.package.value!.superEliteImage !=
                                null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text("الاشتراكات",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge),
                            ),
                          ),        const SizedBox(height: 12),

                        if (controller.package.value!.vipImage != null &&
                            controller.package.value!.vipImage!.isNotEmpty)
                          buildLabeledImage(
                              "VIP", controller.package.value!.vipImage!, width, heigh),

                        if (controller.package.value!.eliteImage != null &&
                            controller.package.value!.eliteImage!.isNotEmpty)
                          buildLabeledImage(
                              "Elite", controller.package.value!.eliteImage!, width, heigh),

                        if (controller.package.value!.superEliteImage != null &&
                            controller.package.value!.superEliteImage!.isNotEmpty)
                          buildLabeledImage("Super Elite",
                              controller.package.value!.superEliteImage!, width, heigh),
                        SizedBox(height: 10,),
                                       if(controller.subOffers.isNotEmpty)       Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "العروض",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                            ,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.zero,
                          child: Row(
                            children: controller.subOffers.value
                                .map(
                                  (c) => SizedBox(
                                      width: width * 0.6,
                                      child: PackageOfferWidget(c,controller.package.value!)),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),


              ],
            ),
          ),
        ),
      );
    });
  }
}
