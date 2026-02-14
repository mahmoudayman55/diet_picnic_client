import 'package:diet_picnic_client/components/custom_app_bar.dart';
import 'package:diet_picnic_client/components/logo_loading_widget.dart';
import 'package:diet_picnic_client/components/package_horizontal_card.dart';
import 'package:diet_picnic_client/controller/offer_packages_controller.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

class OfferPackagesView extends GetView<OfferPackagesController> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      final width = 100.w;
      final heigh = 100.h;
      bool isMobile = deviceType == DeviceType.mobile;
      return Obx(
        () => Scaffold(
          appBar: CustomAppBar(title: controller.offer.name),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: controller.isLoading.value
                ? LogoLoadingWidget()
                : controller.offerPackages.value.isEmpty
                    ? Center(
                        child: Text(
                        "لا يوجد باقات متاحة حالياً داخل العرض",
                        style: Theme.of(context).textTheme.displayLarge,
                      ))
                    : RefreshIndicator(
                      onRefresh: ()async {
                        controller.getPackagesByIds();
                      },
                      child: SingleChildScrollView(physics: BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 12.0),
                                child: Text(
                                  "الباقات المتاحة في العرض",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                ),
                              ),
                              ...controller.offerPackages
                                  .map((e) => InkWell(
                                      onTap: () => Get.toNamed(
                                          AppConstants.packageDetailsPage,
                                          arguments: {"package_id": e.id,"offer_id":controller.offer.id},),
                                      child: PackageHorizontalCard(package: e)))
                                  .toList(),
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
