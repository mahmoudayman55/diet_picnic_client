import 'package:diet_picnic_client/components/book_widget.dart';
import 'package:diet_picnic_client/components/custom_app_bar.dart';
import 'package:diet_picnic_client/components/logo_loading_widget.dart';
import 'package:diet_picnic_client/controller/books_controller.dart';
import 'package:diet_picnic_client/view/animated_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

class BooksView extends GetView<BooksController> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      final width = 100.w;
      final heigh = 100.h;
      bool isMobile = deviceType == DeviceType.mobile;
      return Scaffold(
        appBar: CustomAppBar(title: "المكتبة"),
        body: Obx(
          ()=> Padding(
            padding: const EdgeInsets.all(16),
            child: controller.isLoading.value
                ? const LogoLoadingWidget()
                : AnimatedGridView(
                    itemCount: controller.books.length,
                    itemBuilder: (c, i) => BookWidget(controller.books[i]),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.55,
                    ),
                  ),
          ),
        ),
      );
    });
  }
}
