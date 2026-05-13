import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../core/app_constants.dart';
import 'package_type_card.dart';

class PackageTypeListSection extends StatelessWidget {
  double screenHeight;
  double screenWidth;

  PackageTypeListSection(this.screenHeight,this.screenWidth, {super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> packageTypes = [
      {
        'title': 'التحديات الجماعية',
        'description':
            'تحدي مخصص لإنقاص الوزن بصورة صحية مع مجموعة هتساعدك وتشجعك وتحديات يومية تغير من عاداتنا',
        'gradient': [const Color(0xFF6A11CB), const Color(0xFF2575FC)],
        'image': 'assets/images/coop.png',
        'type': 'group',
      },
      {
        'title': 'المتابعات الفردية',
        'description':
            'متابعة خاصة مع الدكاترة مناسبة للي بيواجهو مشاكل في ثبات الوزن والفئات الخاصة والتغذية العلاجية',
        'gradient': [const Color(0xFFFF512F), const Color(0xFFDD2476)],
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
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: screenHeight*0.3, // Sufficient height for the card
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: packageTypes.length,
            padding: const EdgeInsets.only(left: 4, right: 4),
            itemBuilder: (context, index) {
              final pkg = packageTypes[index];
              return Container(
                width: screenWidth*0.6,
                margin: const EdgeInsets.only(left: 12),
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
              );
            },
          ),
        ),
      ],
    );
  }
}
