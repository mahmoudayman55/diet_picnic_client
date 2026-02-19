import 'package:diet_picnic_client/components/custom_app_bar.dart';
import 'package:diet_picnic_client/components/logo_loading_widget.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';
import '../controller/exercise_system_controller.dart';

class ExerciseSystemView extends GetView<ExerciseSystemController> {
  const ExerciseSystemView({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      final width = 100.w;
      final height = 100.h;

      return Scaffold(
appBar: controller.showAppBar?CustomAppBar(title: "نظام التمارين"):null,
        body: Obx(
            ()=> Padding(
            padding: const EdgeInsets.all(16),
            child: controller.loading.value
                ? LogoLoadingWidget()
                : !controller.hasDietSystem.value
                ? Center(
              child: Text(
                "لم يتم تعيين نظام رياضي",
                style: Theme.of(context).textTheme.displayMedium,
              ),
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Image.asset(
                  "assets/images/workout.png",
                  width: width,
                  height: height * 0.25,
                  fit: BoxFit.contain,
                ),

                Align(alignment: Alignment.center,
                  child: Text(
                    controller.exerciseSystem.name,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: CustomColors.selectedNavBarColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 16),

                // التعليمات العامة
                 if(controller.exerciseSystem.instructions.isNotEmpty)...    [   Text(
                  "التعليمات:",
                  style: Theme.of(context).textTheme.displayLarge
                ),
                Text(
                  controller.exerciseSystem.instructions,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
           SizedBox(height: 10,),
          ],
                Text(
                    "التمارين:",
                    style: Theme.of(context).textTheme.displayLarge
                ),
                // قائمة التمارين
                Expanded(
                  child: ListView.builder(padding: EdgeInsets.zero,
                    itemCount: controller.exerciseSystem.exercises.length,
                    itemBuilder: (context, index) {
                      final exercise =
                      controller.exerciseSystem.exercises[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading:  Icon(Icons.sports_outlined,
                              color: CustomColors.selectedNavBarColor),
                          title: Text(exercise.name,style: Theme.of(context).textTheme.displayMedium,),
                          trailing: IconButton(
                            icon: const Icon(Iconsax.play_circle,
                                color: CustomColors.mainColor),
                            onPressed: () =>
                                controller.openExercise(exercise.url),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
