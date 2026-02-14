import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'dart:developer';

import 'package:diet_picnic_client/components/custom_url_luncher.dart';
import 'package:diet_picnic_client/controller/user_controller.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/core/date_time_formater.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    return Obx(() {
      final user = userController.currentUser.value;

      /// Case 0: User not logged in
      if (user == null) {
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "أهلا بيك في Diet Picnic 👋",
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: CustomColors.selectedNavBarColor,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "أنشئ حساب جديد أو سجل دخولك للاستفادة من خدمات Diet Picnic المختلفة.",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(height: 16),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ConstrainedBox(constraints: BoxConstraints(maxWidth: 115),
                            child: OutlinedButton(
                              onPressed: () =>
                                  Get.toNamed(AppConstants.registerPage),
                              child: Text("إنشاء حساب",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(color: CustomColors.mainColor)),
                              style: OutlinedButton.styleFrom(padding: EdgeInsets.all(8),
                                  side:
                                      BorderSide(color: CustomColors.mainColor)),
                            ),
                          ),
                          ElevatedButton(
                            style: Theme.of(context)
                                .elevatedButtonTheme
                                .style!
                                .copyWith(
                                    padding: WidgetStatePropertyAll(
                                        EdgeInsets.all(8))),
                            onPressed: () =>
                                Get.toNamed(AppConstants.loginPage),
                            child: Text(
                              "تسجيل دخول",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            FlipCard(imagePath: AppConstants.appLogo, text: "Test")
              ],
            ),
          ),
        );
      }

      final userName = user.name.isNotEmpty ? user.name.split(" ").first : "مستخدم";
      final package = user.package;
      final renewalDate = user.renewalDate;

      Widget subscriptionInfo;
log(user.renewalDate.toString(),name: "WELCOMEPACKAGE");
      // Case 1: Never subscribed
      if (package == null || renewalDate == null) {
        subscriptionInfo = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "مرحبًا يا $userName 👋",
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: CustomColors.selectedNavBarColor,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "أنت غير مشترك في أي باقة حتى الآن.\nإستكشف اخر عروضنا وخد خطوة جديدة لحياة صحية أفضل💪",
              style: Theme.of(context).textTheme.displayMedium,
            ),  const SizedBox(height: 8),

            ElevatedButton(
              style: Theme.of(context)
                  .elevatedButtonTheme
                  .style!
                  .copyWith(
                  padding: WidgetStatePropertyAll(
                      EdgeInsets.all(16)),backgroundColor: WidgetStatePropertyAll(Colors.lightGreen)),
              onPressed: () {
                CustomUrlLauncher.launchWhatsApp(
                  phoneNumber: AppConstants.phoneNumber,
                  message: "مرحبًا، أود الاستفسار عن النظام التجريبي المجاني وكيف يمكنني البدء بتجربته. شكرًا لكم!",

                );
              },
              child: Text(
                "اطلب نظامك التجريبي الآن مجاناً",
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      }
      // Case 2: Subscribed but expired
      else if (user.isExpired) {
        subscriptionInfo = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "أهلاً بيك يا $userName 👋",
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: CustomColors.selectedNavBarColor,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
      "كنت مشترك في:\nباقة ${package.name} (${(user.level == null || user.level!.isEmpty) && user.packageGroup != null ? user.packageGroup!.name : (user.level ?? 'غير محدد')})",              style: Theme.of(context).textTheme.displayMedium,
            ),

            const SizedBox(height: 8),
            Text(
              "لكن اشتراكك انتهى يوم ${DateFormat('dd/MM/yyyy').format(renewalDate)} ⏳",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: Colors.red),
            ),
            const SizedBox(height: 8),

            ElevatedButton.icon(
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
          ],
        );
      }
      // Case 3: Subscribed and active
      else {
             subscriptionInfo = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "أهلاً بيك يا $userName 👋",
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: CustomColors.selectedNavBarColor,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "أنت الآن مشترك في:\nباقة ${package.name} (${user.level?.isNotEmpty == true ? user.level! : user.packageGroup?.name ?? 'غير محدد'})"
              ,style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18, color: CustomColors.selectedNavBarColor),
                const SizedBox(width: 6),
                Text(
                  "تاريخ انتهاء: ${DateFormat('dd/MM/yyyy').format(renewalDate)}",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.hourglass_bottom,
                    size: 18, color: CustomColors.selectedNavBarColor),
                const SizedBox(width: 6),
                Text(
                  "متبقي: ${UserController.to.currentUser.value!.timeLeft}",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ],
            ),
          ],
        );
      }

      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: subscriptionInfo),
              FlipCard(imagePath: AppConstants.appLogo, text: "Test")

            ],
          ),
        ),
      );
    });
  }
}




class FlipCard extends StatefulWidget {
  final String imagePath;
  final String text;
  final double width;
  final double height;

  const FlipCard({
    Key? key,
    required this.imagePath,
    required this.text,
    this.width = 100,
    this.height = 100,
  }) : super(key: key);

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_controller.isAnimating) return;

    setState(() {
      _showFront = !_showFront;
    });

    if (_showFront) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * math.pi;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001) // منظور 3D
            ..rotateY(angle);

          final showingFront = angle < math.pi / 2;

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: showingFront
                  ? _buildFront()
                  : Transform(
                transform: Matrix4.rotationY(math.pi),
                alignment: Alignment.center,
                child: _buildBack(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFront() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          widget.imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildBack() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CustomColors.mainColor,
            CustomColors.mainColor.withOpacity(0.8),
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            widget.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}