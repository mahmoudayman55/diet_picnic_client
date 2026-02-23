import 'package:diet_picnic_client/components/lotti_widget.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/core/show_coming_soon_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class KnowledgeSection extends StatefulWidget {
  const KnowledgeSection({super.key});

  @override
  State<KnowledgeSection> createState() => _KnowledgeSectionState();
}

class _KnowledgeSectionState extends State<KnowledgeSection>
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

    return InkWell(onTap: ()=>showComingSoonDialog(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // الخلفية
          Container(
            width: width,
            height: heigh * 0.2,constraints: BoxConstraints(minHeight: 145),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CupertinoColors.systemBlue,
                  Colors.purple,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: ClipRRect(borderRadius: BorderRadius.circular(22),
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "كنز المعلومات",
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(
                            color: Colors.white,

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: width * 0.45,
                          child: Text(
                            "اكتشف مقالات ونصائح مهمة تعزز من معرفتك في مجالات الصحة والرياضة.",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                              color: Colors.white,

                            ),
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
                left: -20,bottom: -100,
                child: SizedBox(
                  width: width * 0.4,
                  height: width * 0.4,
                  child:
                  LottieWidget("assets/animation/tr.png"), // لوتي خاصة بكنز المعلومات
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
