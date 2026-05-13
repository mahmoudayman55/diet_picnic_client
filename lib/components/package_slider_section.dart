import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package_flip_card.dart';
import 'package:get/get.dart';
import '../core/app_constants.dart';

class PackageSliderSection extends StatefulWidget {
  const PackageSliderSection({super.key});

  @override
  State<PackageSliderSection> createState() => _PackageSliderSectionState();
}

class _PackageSliderSectionState extends State<PackageSliderSection> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  double _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
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
        'title': 'الباقات الجماعية',
        'target': 'الأصدقاء والعائلات',
        'smallDesc': 'استمتع برحلة الرشاقة مع من تحب بأسعار مميزة',
        'fullDesc': 'باقتنا الجماعية مصممة لتشجيع المجموعات (3 أشخاص فأكثر) على الالتزام. تشمل متابعة جماعية، تحديات أسبوعية، وخصم يصل إلى 30%. مثالية لزملاء العمل أو أفراد العائلة الواحدة لضمان الدعم المتبادل.',
        'gradient': [const Color(0xFF6A11CB), const Color(0xFF2575FC)],
        'type': 'group',
      },
      {
        'title': 'الباقات الفردية',
        'target': 'الأفراد (تخصيص كامل)',
        'smallDesc': 'خطة مخصصة لك أنت فقط بناءً على احتياجاتك',
        'fullDesc': 'باقاتنا الفردية تركز بشكل كامل على احتياجاتك الخاصة. تشمل تحليلاً دقيقاً لمكونات الجسم، برنامجاً غذائياً متغيراً أسبوعياً، وتواصلاً مباشراً مع أخصائي التغذية لضمان وصولك لهدفك بأسرع وقت وأقل جهد.',
        'gradient': [const Color(0xFFFF512F), const Color(0xFFDD2476)],
        'type': 'individual',
      },
      {
        'title': 'استشارة هاتفية',
        'target': 'إجابات فورية لاستفساراتك',
        'smallDesc': 'اتصال مباشر لمدة 30 دقيقة مع أخصائي التغذية',
        'fullDesc': 'احصل على إجابات فورية لكل تساؤلاتك الغذائية من خلال اتصال هاتفي مباشر. تشمل الجلسة مناقشة عاداتك الحالية، حل مشكلات ثبات الوزن، وتقديم نصائح سريعة وفعالة تناسب يومك.',
        'gradient': [const Color(0xFF11998e), const Color(0xFF38ef7d)],
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
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 60.h,
          child: PageView.builder(
            controller: _pageController,
            itemCount: packageTypes.length,
            itemBuilder: (context, index) {
              final pkg = packageTypes[index];
              
              // Simple scaling animation based on page position
              double scale = 1.0;
              if (_currentPage != null) {
                scale = (1 - (index - _currentPage).abs() * 0.1).clamp(0.8, 1.0);
              }

              return Transform.scale(
                scale: scale,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                  child: PackageFlipCard(
                    title: pkg['title'],
                    target: pkg['target'],
                    smallDesc: pkg['smallDesc'],
                    fullDesc: pkg['fullDesc'],
                    gradient: pkg['gradient'],
                    onAction: () {
                      // Navigate to packages list filtered by type
                      // This part depends on how you want to filter, for now we go to packages page
                      Get.toNamed(AppConstants.packageTypePage, arguments: pkg['type']);
                    },
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(packageTypes.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 8,
              width: _currentPage.round() == index ? 24 : 8,
              decoration: BoxDecoration(
                color: _currentPage.round() == index 
                    ? const Color(0xFF2575FC) 
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}
