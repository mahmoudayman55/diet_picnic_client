import 'package:diet_picnic_client/components/custom_cached_network_image.dart';
import 'package:diet_picnic_client/controller/user_controller.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/view/menu_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onNotificationTap;
  final bool showNotificationIcon;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onNotificationTap,
    this.showNotificationIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> AppBar(surfaceTintColor: Colors.white,
        title: Text(
          title,
          style: Theme
              .of(context)
              .textTheme
              .displayLarge,
        ),
        actions: [
          // if(showNotificationIcon)     IconButton(
          //        onPressed: onNotificationTap ?? () {
          //       //   Get.to(NotificationsView());
          //        },
          //        icon: const Icon(Iconsax.notification),
          //      ),
          Padding(
            padding: const EdgeInsets.all(3),
            child: IconButton(onPressed: () {
              Get.to(MenuView());
            }, icon: UserController.to.isLoggedIn ? ClipRRect(borderRadius: BorderRadius.circular(50),
              child:  Obx(
                ()=> AspectRatio(aspectRatio: 1,
                  child: CustomCachedNetworkImage(
                      imageUrl: UserController.to.currentUser.value!.image ??
                          AppConstants.dummyPerson1Image,fit: BoxFit.cover,

                  ),
                ),
              ),
            ): Icon(Icons.person_outline)),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            color: CustomColors.shadowLight,
            height: 1,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
