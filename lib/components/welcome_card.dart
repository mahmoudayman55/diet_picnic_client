import 'dart:math' as math;
import 'dart:developer';
import 'dart:math';
import 'dart:ui';
import 'package:diet_picnic_client/controller/theme_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:diet_picnic_client/components/custom_url_luncher.dart';
import 'package:diet_picnic_client/controller/user_controller.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/core/date_time_formater.dart';

class WelcomeCard extends StatefulWidget {
  const WelcomeCard({super.key});

  @override
  State<WelcomeCard> createState() => _WelcomeCardState();
}

class _WelcomeCardState extends State<WelcomeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showFront = true;
  String _currentMessage = "";

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

    _currentMessage = getRandomMessage();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_controller.isAnimating) return;

    if (_showFront) {
      _currentMessage = getRandomMessage();
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _showFront = !_showFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Register dependency on currentUser so the widget rebuilds when it changes.
      // We pass the user to _buildFront to use the data.
      final userController = Get.find<UserController>();
      final user = userController.currentUser.value;

      return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * math.pi;
          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001) // 3D perspective
            ..rotateY(angle);

          // Determine if we are showing the front or back based on rotation angle
          final showingFront = angle < math.pi / 2;

          return Transform(
            transform: transform,
            alignment: Alignment.center,
            child: showingFront
                ? _buildFront(context, user)
                : Transform(
                    transform: Matrix4.rotationY(math.pi),
                    alignment: Alignment.center,
                    child: _buildBack(context),
                  ),
          );
        },
      );
    });
  }

  String getRandomMessage() {
    final messages = [
      // تحفيز
      "كل يوم بتصوم فيه خطوة أقرب لجسمك اللي عايزه 💪",
      "رمضان أحسن وقت تبدأ فيه رحلتك الصح 🌙",
      "الإرادة اللي بتصوم بيها.. هي نفسها اللي هتغير بيها حياتك 🔥",
      "متستسهلش في إفطارك.. جسمك يستاهل الأحسن ✨",
      "كل وجبة صح بتاكلها دي انجاز يستاهل فخر 🏆",
      "الجوع في النهار مش عذر للإفراط بالليل 😉",
      "صيامك عبادة.. وأكلك الصح مسؤولية 💚",
      "إنت أقوى من أي وجبة غير صحية 💥",
      "رمضان مش وقت تزيد وزنك.. ده وقت تغيّر عاداتك 🌿",
      "كل خطوة صغيرة بتعملها دلوقتي.. هتشوف نتيجتها قريب 🎯",

      // ترويج Diet Picnic
      "Diet Picnic بيساعدك تاكل صح حتى في رمضان 🥗🌙",
      "مش لازم تحرم نفسك.. Diet Picnic عنده الحل 😍",
      "وجبات Diet Picnic متوازنة.. وهتخليك شبعان طول اليوم 💪",
      "إفطار صح مع Diet Picnic = رمضان أخف وأحلى ✨",
      "Diet Picnic مش بس أكل.. ده أسلوب حياة 🌟",
      "خلي Diet Picnic يكون رفيقك في رمضان 🌙❤️",
      "سحورك مع Diet Picnic هيديك طاقة طول اليوم ⚡",
      "Diet Picnic فاكرك حتى في رمضان 🥰",
      "ابدأ رمضان صح.. ابدأ مع Diet Picnic 🚀",
      "Diet Picnic.. لأن جسمك يستاهل الأفضل دايمًا 💚",

      // نصايح سريعة
      "اشرب مياه كتير بين الإفطار والسحور 💧",
      "افطر على تمر ومياه.. وهدي نفسك قبل الأكل 🌴",
      "السحور مش وجبة تتعداها! 🍳",
      "شوربة خفيفة = بداية إفطار مثالية 🥣",
      "المقليات والسكريات عدوك في رمضان 🚫",
      "نومك الكافي بيساعدك تتحكم في أكلك 😴",
      "إفطارك ميكونش وليمة.. خلي الأكل معقول 🍽️",
      "التمر طاقة طبيعية وسريعة لجسمك ⚡🌴",
    ];

    final random = Random();
    return messages[random.nextInt(messages.length)];
  }

  Widget _buildBack(BuildContext context) {
    return GestureDetector(
      onTap: _flip,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 2,
        child: Stack(
          children: [
            Container(constraints: BoxConstraints(minHeight: 160),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.22,
                // Approximate height to match front content roughly
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      // ThemeController.to.isDarkMode
                      //     ?
                      Color(0xFF3E2723),
                          // : Color(0xFFFFE4B9), // بني داكن
                      Color(0xFFFF9800), // برتقالي (يطابق اللوجو)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Stack(
                    children: [
                      // دوائر شفافة للديكور
                      Positioned(
                        top: -30,
                        left: -20,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white.withOpacity(0.1),
                        ),
                      ),

                      Positioned(
                        bottom: -20,
                        right: -40,
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      Positioned(
                          top: 0,
                          left: 0,


                          child: Center(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,

                              child: Stack(
                                children: [
                                  // الظل
                                  // Transform.translate(
                                  //   offset: Offset(2, 2),
                                  //   child: ImageFiltered(
                                  //     imageFilter: ImageFilter.blur(
                                  //         sigmaX: 6, sigmaY: 6),
                                  //     child: ColorFiltered(
                                  //       colorFilter: ColorFilter.mode(
                                  //         Colors.amber.withOpacity(0.6),
                                  //         BlendMode.srcATop,
                                  //       ),
                                  //       child: Opacity(
                                  //           opacity: 0.3,
                                  //           child: Image.asset(
                                  //               "assets/images/logow.png")),
                                  //     ),
                                  //   ),
                                  // ),
                                  // الصورة الأصلية مع blur
                                  ImageFiltered(
                                    imageFilter:
                                        ImageFilter.blur(sigmaX: 0.3, sigmaY: 0.3),
                                    child: Image.asset("assets/images/logo.png"),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "\n${_currentMessage}",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:  Colors.white

                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            Positioned(
                right: 0,
                bottom: 0,
                child: SizedBox(
                  height: 80,
                  child: Image.asset("assets/images/lighter.png"),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildFront(BuildContext context, dynamic user) {
    // We use the 'user' passed from Obx to render the content

    // Logo widget that triggers the flip
    final logoWidget = GestureDetector(
      onTap: _flip,
      child: Container(
        width: 100,
        height: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            AppConstants.appLogo,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

    /// Case 0: User not logged in
    if (user == null) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 120),
                          child: OutlinedButton(
                            onPressed: () =>
                                Get.toNamed(AppConstants.registerPage),
                            style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.all(8),
                                side: const BorderSide(
                                    color: CustomColors.mainColor)),
                            child: Text("إنشاء حساب",
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall!
                                    .copyWith(color: CustomColors.mainColor)),
                          ),
                        ),
                        ElevatedButton(
                          style: Theme.of(context)
                              .elevatedButtonTheme
                              .style!
                              .copyWith(
                                  padding: const WidgetStatePropertyAll(
                                      EdgeInsets.all(8))),
                          onPressed: () => Get.toNamed(AppConstants.loginPage),
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
              logoWidget,
            ],
          ),
        ),
      );
    }

    final userName =
        user.name.isNotEmpty ? user.name.split(" ").first : "مستخدم";
    final package = user.package;
    final renewalDate = user.renewalDate;

    Widget subscriptionInfo;

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
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            style: Theme.of(context).elevatedButtonTheme.style!.copyWith(
                padding: const WidgetStatePropertyAll(EdgeInsets.all(16)),
                backgroundColor:
                    const WidgetStatePropertyAll(Colors.lightGreen)),
            onPressed: () {
              CustomUrlLauncher.launchWhatsApp(
                phoneNumber: AppConstants.phoneNumber,
                message:
                    "مرحبًا، أود الاستفسار عن النظام التجريبي المجاني وكيف يمكنني البدء بتجربته. شكرًا لكم!",
              );
            },
            child: Text(
              "اطلب نظامك التجريبي الآن مجاناً",
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
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
            "كنت مشترك في:\nباقة ${package.name} (${(user.level == null || user.level!.isEmpty) && user.packageGroup != null ? user.packageGroup!.name : (user.level ?? 'غير محدد')})",
            style: Theme.of(context).textTheme.displayMedium,
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            icon: const Icon(Iconsax.refresh, color: Colors.white),
            label: const Text(
              "تجديد الاشتراك",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
            "أنت الآن مشترك في:\nباقة ${package.name} (${user.level?.isNotEmpty == true ? user.level! : user.packageGroup?.name ?? 'غير محدد'})",
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today,
                  size: 18, color: CustomColors.selectedNavBarColor),
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
            logoWidget,
          ],
        ),
      ),
    );
  }
}
