import 'package:diet_picnic_client/components/section_card.dart';
import 'package:diet_picnic_client/controller/theme_controller.dart';
import 'package:diet_picnic_client/controller/user_controller.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/core/date_time_formater.dart';
import 'package:diet_picnic_client/models/client_profile_model.dart';
import 'package:diet_picnic_client/models/week_progress_model.dart';
import 'package:diet_picnic_client/view/add_progrss_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProgressSection extends StatelessWidget {
  final ClientProfileModel client;

  const ProgressSection({Key? key, required this.client}) : super(key: key);

  Widget _buildProgressRow(BuildContext context, WeekProgressModel progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeController.to.isDarkMode?CustomColors.shadowLight:Colors.white,
        borderRadius: BorderRadius.circular(12),

        border: Border.all(
          color: CustomColors.borderColor,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    DateTimeFormatter.dateTimeToFullDate(progress.date),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color:ThemeController.to.isDarkMode?CustomColors.mainColor: CustomColors.selectedNavBarColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                progress.excuse.isNotEmpty
                    ? Center(
                  child: Text(
                    "لم يتم إرسال المتابعة الإسبوعية",
                    style: Theme.of(context)
                        .textTheme
                        .displayLarge!
                        .copyWith(color: Colors.red),
                  ),
                )
                    : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildProgressItem(
                              context,
                              'الوزن',
                              '${progress.weight} كجم',
                              "assets/images/weight.png"),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildProgressItem(
                              context,
                              'الحوض',
                              '${progress.pelvis} سم',
                              "assets/images/palvies.png"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildProgressItem(
                              context,
                              'وسط الذراع',
                              '${progress.rightArm} سم',
                              "assets/images/arm.png"),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildProgressItem(
                              context,
                              'الوسط',
                              '${progress.waist} سم',
                              "assets/images/waist.png"),
                        ),
                      ],
                    ),
                  ],
                ),
                if (progress.notes != null && progress.notes!.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border(
                        right: BorderSide(
                          color: CustomColors.mainColor,
                          width: 4,
                        ),
                      ),
                    ),
                    child: Text(
                      progress.notes!,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(

                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
                if (progress.excuse.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border(
                        right: BorderSide(
                          color: CustomColors.mainColor,
                          width: 4,
                        ),
                      ),
                    ),
                    child: Text(
                      progress.excuse,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(

                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // 🔧 Edit button
          Positioned(
            top:-15,
            left: -15,
            child: IconButton(
              icon: const Icon(Icons.edit, color: CustomColors.selectedNavBarColor),
              onPressed: () {
                Get.to(AddWeekProgressView(), arguments: progress);
                // OR if you don't use named routes:
                // Get.to(() => const AddWeekProgressView(), arguments: progress);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(
      BuildContext context,
      String label,
      String value,
      String imageAssetPath,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        // color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey.shade300,
        ),
      ),
      child: Column(
        children: [
          Image.asset(
            imageAssetPath,
            width: 26,
            height: 26,
            fit: BoxFit.contain,
            color:ThemeController.to.isDarkMode?CustomColors.mainColor: CustomColors.selectedNavBarColor, // Optional tint
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color:ThemeController.to.isDarkMode?CustomColors.mainColor: CustomColors.selectedNavBarColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    if (client.weekProgressList.isEmpty) {
      return Obx(
            () =>
            Column(

              children: [
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'لا توجد بيانات تقدم متاحة',
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: UserController.to.currentUser.value!.weeklyFollowUpSent?null:() async {
                    Get.to(AddWeekProgressView());
                  },
                  icon: const Icon(Icons.add),
                    label: const Text('إضافة تقدم أسبوعي'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.mintGold,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 18),
                  ),
                ),
              ],
            ),
      );
    }

    final sortedProgress = List.from(client.weekProgressList)
      ..sort((a, b) => b.date.compareTo(a.date));

    return Column(

      children: [
        ...sortedProgress.map((progress) =>
            _buildProgressRow(context, progress)),



      ],
    );
  }
}
