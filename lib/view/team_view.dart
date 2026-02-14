import 'package:diet_picnic_client/components/animated_column.dart';
import 'package:diet_picnic_client/components/custom_app_bar.dart';
import 'package:diet_picnic_client/components/custom_cached_network_image.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:flutter/material.dart';

class TeamworkScreen extends StatelessWidget {
  const TeamworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "فريق العمل"),
      body: SingleChildScrollView(
        child: AnimatedColumn(
          children: const [
            DoctorCard(
              imageUrl:
              "drayman.jpg",
              name: "د. أيمن سعد العزاوي",
              title: "أخصائي الروماتيزم والتغذية العلاجية",
              description: """
🎓 بكالوريوس الطب والجراحة - جامعة المنصورة  
🩺 ماجستير الروماتيزم وأمراض المفاصل والعمود الفقري وآلام الركبة  
💪 أخصائي التأهيل الرياضي وتأهيل السمنة والنحافة  
🥗 أخصائي التغذية العلاجية  
📚 دبلومة التغذية العلاجية - المعهد القومي
""",
            ),

            DoctorCard(
              imageUrl:
                  "drlobna.jpg",
              name: "د. لبنى يادم أبوقمير",
              title: "أخصائية السمنة والنحافة والتأهيل الرياضي",
              description: """
🎓 بكالوريوس الصيدلة - جامعة الإسكندرية  
📜 البورد الأمريكي في التغذية العلاجية الإكلينيكية  
🏅 شهادة SCOPE من الفيدرالية الدولية للسمنة (المملكة المتحدة)  
🧪 أخصائية تحاليل طبية  
⚖️ أخصائية السمنة والنحافة والتأهيل الرياضي  
🥗 أخصائية التغذية العلاجية الإكلينيكية
""",
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String title;
  final String description;

  const DoctorCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.asset("assets/images/${imageUrl}"),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              name,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(color: CustomColors.mainColor),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }
}
