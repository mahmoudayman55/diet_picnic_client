import 'package:diet_picnic_client/components/offer_price_widget.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/models/offer_model.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class OfferCardWidget extends StatelessWidget {
  OfferModel offer;
   OfferCardWidget(this.offer,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background Image (ثابتة)
              Positioned.fill(
                child: Image.network(
                  offer.coverImage,
                  fit: BoxFit.cover,
                ),
              ),

              // // Gradient Overlay
              // Positioned.fill(
              //   child: Container(
              //     decoration: BoxDecoration(
              //       gradient: LinearGradient(
              //         begin: Alignment.topCenter,
              //         end: Alignment.bottomCenter,
              //         colors: [
              //           Colors.black.withOpacity(0.2),
              //           Colors.black.withOpacity(0.8),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              //
              // // Texts
              // Positioned(
              //   left: 16,
              //   right: 16,
              //   bottom: 16,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         "VIP",
              //         style: Theme.of(context)
              //             .textTheme
              //             .headlineLarge!
              //             .copyWith(color: Colors.white),
              //       ),
              //   OfferPriceWidget(
              //         oldPrice: 500,
              //         offerPrice: 250,
              //         oldPriceColor: Colors.white,mainAxisAlignment: MainAxisAlignment.start,
              //         offerPriceColor: CustomColors.mainColor,
              //       ),
              //       const SizedBox(height: 8),
              //       Text(
              //         "عرض الصيف 3شهور + شهر هدية",
              //         style: Theme.of(context)
              //             .textTheme
              //             .displayLarge!
              //             .copyWith(color: Colors.white),
              //       ),
              //
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
