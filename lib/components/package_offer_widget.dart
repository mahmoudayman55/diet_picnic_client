import 'package:diet_picnic_client/components/custom_cached_network_image.dart';
import 'package:diet_picnic_client/components/custom_url_luncher.dart';
import 'package:diet_picnic_client/components/offer_price_widget.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/models/offer_model.dart';
import 'package:diet_picnic_client/models/package_model.dart';
import 'package:diet_picnic_client/view/offer_details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PackageOfferWidget extends StatelessWidget {
  SubOffer subOffer;
  PackageModel package;

  PackageOfferWidget(this.subOffer, this.package, {super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;

    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // responsive width
      child: IntrinsicHeight(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio:1, // keeps image responsive
                child: CustomCachedNetworkImage(
               imageUrl:    subOffer.image,
                  // replace with your asset if needed
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 12),
         if(package.type!="group")   Text(
              subOffer.level.capitalize!,
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              subOffer.name,
              style: Theme
                  .of(context)
                  .textTheme
                  .displayMedium,
            ),
            const SizedBox(height: 8),
            OfferPriceWidget(oldPrice: subOffer.oldPrice, offerPrice: subOffer.newPrice),
            SizedBox(
                width: double.maxFinite,
                child: OutlinedButton(
                    style: ButtonStyle(
                        side: WidgetStateProperty.all(BorderSide(
                            color: CustomColors.selectedNavBarColor,
                            width: 1))),
                    onPressed: () {
                      CustomUrlLauncher.launchWhatsApp(
                        phoneNumber: AppConstants.phoneNumber,
                        message:
                        "مرحبًا 👋\n"
                        "حابب اشترك مع *Diet Picnic* 🥗\n\n"
                        "📦 الباقة: ${package.name}\n"
                      "${package.type != 'group' ? "🎯 المستوى: ${subOffer.level}\n" : ""}"
                      "💡 العرض: ${subOffer.name}\n\n"
                      "ممكن أعرف التفاصيل وطريقة الاشتراك؟ 🙏",

                      );


                      // Get.toNamed(AppConstants.offersDetailsPage,arguments: { "images": [
                      //  AppConstants.dummyOfferImage,
                      //  AppConstants.dummyOfferImage,
                      //  AppConstants.dummyOfferImage,
                      //  AppConstants.dummyOfferImage,
                      // ],});
                    },
                    child: Text(
                      "إشترك الآن",
                      style: Theme
                          .of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(color: CustomColors.selectedNavBarColor),
                    )))
          ],
        ),
      ),
    );
  }
}
