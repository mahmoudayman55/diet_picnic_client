import 'package:diet_picnic_client/components/custom_cached_network_image.dart';
import 'package:diet_picnic_client/components/custom_url_luncher.dart';
import 'package:diet_picnic_client/controller/user_controller.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookWidget extends StatelessWidget {
  BookModel book;

  BookWidget(this.book, {super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.all(5),

      decoration: BoxDecoration(
        color:CustomColors.dividerLight.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.08),
        //     blurRadius: 8,
        //     offset: const Offset(0, 4),
        //   ),
        // ],
      ),
      // responsive width
      child: IntrinsicHeight(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 9 / 12, // keeps image responsive
                      child: CustomCachedNetworkImage(
                        imageUrl: book.imageUrl,
                        // replace with your asset if needed
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    book.name,
                    style: Theme.of(context).textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                      width: double.maxFinite,
                      child: OutlinedButton.icon(
                          icon: Icon(Icons.link,
                              color: CustomColors.selectedNavBarColor),
                          style: ButtonStyle(
                              side: WidgetStateProperty.all(BorderSide(
                                  color: CustomColors.selectedNavBarColor,
                                  width: 1))),
                          onPressed: () {
                            CustomUrlLauncher.launchGoogleDriveFolder(book.link);
                          },
                          label: Text(
                            "إستكشاف",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    color: CustomColors.selectedNavBarColor),
                          )))
                ],
              ),
            ),    if (!book.availableForAll&&(!UserController.to.isLoggedIn||!UserController.to.isSubscribed))
              Container(

                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),child: Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline,color: Colors.white,),
                  SizedBox(height: 8,),
                  Text("هذا الكتاب متاح للمشتركين فقط",style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.white),textAlign: TextAlign.center,)
                ],
              ),
              ),
          ],
        ),
      ),
    );
  }
}
