import 'package:diet_picnic_client/components/custom_cached_network_image.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/models/package_model.dart';
import 'package:diet_picnic_client/view/package_details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PackageWidget extends StatelessWidget {
  PackageModel package;

  PackageWidget(this.package, {super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(onTap: ()=>Get.toNamed(AppConstants.packageDetailsPage,arguments: {'package_id':package.id}),
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 1, // keeps image responsive
                child: CustomCachedNetworkImage(
                  imageUrl: package.baseImage,
                  // replace with your asset if needed
                  fit: BoxFit.cover,
                ),
              ),
            ),
            //const SizedBox(height: 12),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Column(
            //     children: [
            //       Center(
            //         child: Text(
            //         package.name,
            //           style: Theme.of(context).textTheme.headlineSmall,
            //         ),
            //       ),
            //       Center(
            //         child: Text(
            //           package.about,
            //           style: Theme.of(context).textTheme.displayMedium,
            //           overflow: TextOverflow.ellipsis,
            //           maxLines: 1,
            //         ),
            //       ),
            //
            //       SizedBox(
            //           width: double.maxFinite,
            //           child: OutlinedButton(
            //               style: ButtonStyle(
            //                   side: WidgetStateProperty.all(BorderSide(
            //                       color: CustomColors.selectedNavBarColor,
            //                       width: 1))),
            //               onPressed: () {
            //                Get.toNamed(AppConstants.packageDetailsPage,arguments: {'package_id':package.id});
            //               },
            //               child: Text(
            //                 "تفاصيل",
            //                 style: Theme.of(context)
            //                     .textTheme
            //                     .displayMedium!
            //                     .copyWith(color: CustomColors.selectedNavBarColor),
            //               ))),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
