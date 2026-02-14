import 'package:diet_picnic_client/components/animated_column.dart';
import 'package:diet_picnic_client/components/custom_app_bar.dart';
import 'package:diet_picnic_client/controller/diet_controller.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

class DietView extends GetView<DietController> {
  const DietView({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      final width = 100.w;
      final height = 100.h;

      return Scaffold(
        appBar: controller.showAppBar?const CustomAppBar(title: "النظام الغذائى"):null,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // الصورة
              Image.asset(
                "assets/images/diet.png",
                width: width * 0.8,
                height: height * 0.25,
                fit: BoxFit.cover,
              ),

              const SizedBox(height: 20),

              // اسم النظام
              // Text(
              //   controller.dietSystem.name,
              //   style: Theme.of(context).textTheme.headlineMedium!.copyWith(
              //     fontWeight: FontWeight.bold,
              //     color: CustomColors.selectedNavBarColor,
              //   ),
              //   textAlign: TextAlign.center,
              // ),

              const SizedBox(height: 16),

              // زر فتح اللينك
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor:CustomColors.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed:()=> controller.openUrl(),
                icon: const Icon(Iconsax.link, color: Colors.white),
                label: Text(
                  "استكشاف النظام",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // التعليمات
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "التعليمات:",
                  style: Theme.of(context).textTheme.displayLarge
                ),
              ),

              const SizedBox(height: 12),

              ...controller.dietSystem.instructions.map(
                    (instr) => ListTile(
                  leading: const Icon(Iconsax.tick_circle, color: CustomColors.selectedNavBarColor),
                  title: Text(
                    instr,
                    style: Theme.of(context).textTheme.displayMedium,
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
