import 'package:diet_picnic_client/components/lotti_widget.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/view/books_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
class ReadingSection extends StatefulWidget {
  const ReadingSection({super.key});

  @override
  State<ReadingSection> createState() => _ReadingSectionState();
}

class _ReadingSectionState extends State<ReadingSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: -100, end: -70).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final heigh = MediaQuery.of(context).size.height;

    return InkWell(onTap: ()=> Get.toNamed(AppConstants.booksPage),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // خلفية منحنية بتدرج لوني
          Container(
            width: width*0.44,
            height: heigh * 0.16,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.redAccent.withOpacity(0.7),
                  Colors.red,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:  BorderRadius.circular(22),
            ),
            child: ClipRRect(borderRadius: BorderRadius.circular(22),
              child: Stack(
                children: [
                  // دوائر ديكورية شفافة
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "المكتبة",
                          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                            color: Colors.white,

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "استمتع بقراءة كتب مميزة في الصحة والرياضة.",
                          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            color: Colors.white

                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // لوتي متحرك
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                top: _animation.value,
                left: -35,bottom: 15,
                child: SizedBox(
                  width: width * 0.3,
                  height: width * 0.8,
                  child: LottieWidget("assets/animation/reading.png"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
