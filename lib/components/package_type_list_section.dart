import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../core/app_constants.dart';
import 'package_type_card.dart';

class PackageTypeListSection extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;

  const PackageTypeListSection(this.screenHeight, this.screenWidth, {super.key});

  @override
  State<PackageTypeListSection> createState() => _PackageTypeListSectionState();
}

class _PackageTypeListSectionState extends State<PackageTypeListSection> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> packageTypes = [
      {
        'title': 'التحديات الجماعية',
        'description':
            'تحدي مخصص لإنقاص الوزن بصورة صحية مع مجموعة هتساعدك وتشجعك وتحديات يومية تغير من عاداتنا',
        'gradient': [const Color(0xFFDD2476), const Color(0xFFFF512F)],
        'image': 'assets/images/coop.png',
        'type': 'group',
      },
      {
        'title': 'المتابعات الفردية',
        'description':
            'متابعة خاصة مع الدكاترة مناسبة للي بيواجهو مشاكل في ثبات الوزن والفئات الخاصة والتغذية العلاجية',
        'gradient': [const Color(0xFF6A11CB), const Color(0xFF2575FC)],
        'image': 'assets/images/indv.png',
        'type': 'individual',
      },
      {
        'title': 'استشارة هاتفية',
        'description':
            'تواصل مباشر وسريع للرد على كافة استفساراتك الغذائية وحل مشكلات ثبات الوزن.',
        'gradient': [const Color(0xFF11998e), const Color(0xFF38ef7d)],
        'image': 'assets/images/call.png',
        'type': 'consultation',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            "اختر باقتك المفضلة",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: widget.screenHeight * 0.3, // Sufficient height for the card
          child: PageView.builder(
            controller: _pageController,
            itemCount: packageTypes.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final pkg = packageTypes[index];
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = (_pageController.page! - index).abs();
                    value = (1 - (value * 0.08)).clamp(0.0, 1.0);
                  } else {
                    value = index == 0 ? 1.0 : 0.92;
                  }
                  return Transform.scale(
                    scale: value,
                    child: child,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: PackageTypeCard(
                    title: pkg['title'],
                    description: pkg['description'],
                    gradient: pkg['gradient'],
                    image: pkg['image'],
                    onTap: () {
                      Get.toNamed(AppConstants.packageTypePage,
                          arguments: pkg['type']);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
