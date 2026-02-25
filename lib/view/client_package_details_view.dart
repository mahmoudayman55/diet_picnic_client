import 'package:diet_picnic_client/components/animated_column.dart';
import 'package:diet_picnic_client/components/custom_app_bar.dart';
import 'package:diet_picnic_client/components/custom_url_luncher.dart';
import 'package:diet_picnic_client/controller/user_controller.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/core/date_time_formater.dart';
import 'package:diet_picnic_client/models/client_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

class ClientPackageDetailsView extends StatelessWidget {
  const ClientPackageDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ClientProfileModel client = UserController.to.currentUser.value!;

    return Sizer(
      builder: (context, orientation, deviceType) {
        final width = 100.w;
        final height = 100.h;
        bool isMobile = deviceType == DeviceType.mobile;

        return Scaffold(
          appBar: CustomAppBar(title: "باقتي"),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: AnimatedColumn(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCard(
                    context,
                    icon: Icons.done,
                    title: "حالة الباقة",
                    value: client.isExpired ? "منتهية" : "نشطة",
                  ),
                  _buildCard(
                    context,
                    icon: Iconsax.box,
                    title: "الباقة",
                    value: client.package!.name,
                  ),
                  if (client.packageGroup != null)
                    _buildCard(
                      context,
                      icon: Iconsax.people,
                      title: "المجموعة",
                      value: client.packageGroup?.name ?? "غير محدد",
                    ),
               if(client.level!=null)   _buildCard(
                    context,
                    icon: Iconsax.filter_square,
                    title: "الفئة",
                    value: client.level!,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildCard(
                          context,
                          icon: Iconsax.calendar_1,
                          title: "تاريخ الاشتراك",
                          value: DateTimeFormatter.dateTimeToFullDate(
                              client.subscriptionDate!),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildCard(
                          context,
                          icon: Iconsax.play,
                          title: "تاريخ البداية",
                          value: DateTimeFormatter.dateTimeToFullDate(
                              client.startDate!),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildCard(
                          context,
                          icon: Iconsax.refresh,
                          title: "تاريخ التجديد",
                          value: DateTimeFormatter.dateTimeToFullDate(
                              client.renewalDate!),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildCard(
                          context,
                          icon: Iconsax.timer,
                          title: "الوقت المتبقي",
                          value: client.timeLeft,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // حالة الاشتراك + زرار تجديد
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        CustomUrlLauncher.launchWhatsApp(
                          phoneNumber: AppConstants.phoneNumber,
                          message: "مرحبًا 👋\n"
                              "أنا ${UserController.to.currentUser.value!.name} مشترك سابق في *Diet Picnic* 🥗\n\n"
                              "حابب أعمل *تجديد اشتراك* 💪\n\n"
                              "📦 الباقة الحالية: ${UserController.to.currentUser.value!.package!.name}\n"
                              "📅 تاريخ تجديد الاشتراك: ${DateTimeFormatter.dateTimeToFullDate(UserController.to.currentUser.value!.renewalDate!)}\n\n"
                              "ممكن أعرف تفاصيل التجديد؟ 🙏",
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.selectedNavBarColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      icon: const Icon(Iconsax.refresh, color: Colors.white),
                      label: const Text(
                        "تجديد الاشتراك",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard(BuildContext context,
      {required IconData icon, required String title, required String value}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: CustomColors.mintGold.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: CustomColors.mintGold,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value.isNotEmpty ? value : "غير محدد",
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
