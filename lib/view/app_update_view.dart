import 'package:diet_picnic_client/components/logo_loading_widget.dart';
import 'package:diet_picnic_client/components/lotti_widget.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diet_picnic_client/controller/app_update_controller.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';

class AppUpdateView extends StatelessWidget {
  final controller = Get.find<AppUpdateController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        // 🔹 Maintenance mode first
        if (controller.inMaintenance.value) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LottieWidget("assets/images/maintenance.png"),
                  const SizedBox(height: 24),
                  Text(
                    "⚙️ التطبيق تحت الصيانة",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: CustomColors.mainColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "نقوم حالياً ببعض أعمال الصيانة لتحسين تجربتك.\nيرجى المحاولة لاحقًا.",
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: CustomColors.textBlack54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        // 🔹 Update mode
        final days = controller.daysRemaining.value;
        final deadline = controller.deadline.value;
        final now = DateTime.now();

        bool isExpired = deadline != null && now.isAfter(deadline);
        String message;

        if (isExpired) {
          message =
          "تم إصدار نسخة جديدة من التطبيق. يجب عليك تحديث التطبيق للاستمرار في استخدامه.";
        } else {
          message =
          "يوجد إصدار جديد من التطبيق. لديك ${days > 0 ? "$days يوم" : "أقل من يوم"} قبل أن يصبح التحديث إلزاميًا.";
        }

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: controller.isLoading.value
                ? LogoLoadingWidget(showIndicator: false,size: 200,)
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LottieWidget("assets/images/update.png"),
                const SizedBox(height: 24),
                Text(
                  "تحديث متاح",
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: controller.launchPlayStore,
                  icon: const Icon(Icons.system_update),
                  label: Text(
                    "تحديث الآن",
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.mainColor,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                ),
                if (!isExpired) ...[
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () =>
                        Get.offAllNamed(AppConstants.navigatorPage),
                    style: OutlinedButton.styleFrom(
                        side:
                        BorderSide(color: CustomColors.mainColor)),
                    child: Text(
                      "لاحقًا",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(color: CustomColors.mainColor),
                    ),
                  ),
                ]
              ],
            ),
          ),
        );
      }),
    );
  }
}
