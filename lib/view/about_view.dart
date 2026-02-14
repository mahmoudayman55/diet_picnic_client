import 'package:diet_picnic_client/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(title: 'حول التطبيق'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "🥗 حول تطبيق دايت بيكنك | Diet Picnic",
              style: theme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "مرحبًا بك في دايت بيكنك، تطبيقك الذكي لإدارة أسلوب حياتك الصحي بطريقة بسيطة وممتعة 🎯 "
                  "هدفنا هو مساعدتك على الوصول إلى أفضل نسخة من نفسك، من خلال خطط غذائية وتمارين رياضية مخصصة لك، "
                  "مصممة بعناية لتناسب احتياجاتك اليومية ومستوى نشاطك وتاريخك الصحي.\n\n"
                  "في دايت بيكنك، نؤمن أن الصحة تبدأ من الوعي، وأن التوازن هو السر — لا حرمان، ولا تعقيد. "
                  "فقط نظام صحي مبني على العلم، المرونة، والاختيار الذكي.",
              style: theme.displayMedium?.copyWith(height: 1.6),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),

            _buildSectionTitle(context, "🌿 الرؤية"),
            Text(
              "أن نكون منصة رائدة في تقديم أسلوب حياة صحي متكامل، لا يقتصر على التغذية فحسب، "
                  "بل يساعد كل شخص على الوصول لأفضل نسخة من نفسه، من خلال التوازن بين الجسد والعقل والعادات اليومية الصحية.",
              style: theme.displayMedium?.copyWith(height: 1.6),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),

            _buildSectionTitle(context, "💬 الرسالة"),
            Text(
              "نقدم خطط تغذية مرنة ومخصصة، مدعومة بتمارين متدرجة لتحسين الأداء البدني، سواء لأغراض علاجية أو رياضية. "
                  "وبصفتنا فريقًا طبيًا متخصصًا، نعمل على تغيير مفهوم 'الدايت التقليدي' ليصبح أسلوب حياة صحي مستدام، "
                  "بعيدًا عن الحرمان، ومبنيًا على الوعي والفهم والاختيار الذكي.",
              style: theme.displayMedium?.copyWith(height: 1.6),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),

            _buildSectionTitle(context, "🎯 الهدف"),
            Text(
              "نسعى إلى مساعدة كل شخص في بناء علاقة صحية مع الطعام وجسده، قائمة على الفهم والمرونة، لا على القواعد الصارمة. "
                  "هدفنا نشر ثقافة الوعي الصحي وتمكين الأفراد من تبنّي نمط حياة متوازن ومستدام، ينعكس إيجابيًا على صحتهم الجسدية والنفسية.",
              style: theme.displayMedium?.copyWith(height: 1.6),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),

            _buildSectionTitle(context, "💪 ماذا يقدم لك التطبيق؟"),
            Text(
              "• 🧠 تحليل شامل لجسمك وأهدافك الصحية\n"
                  "• 🍽️ أنظمة غذائية مخصصة تناسب نمط حياتك\n"
                  "• 🏃‍♀️ خطط تمارين مدروسة ومناسبة لمستواك\n"
                  "• 📈 متابعة مستمرة للتقدم في الوزن والمقاسات\n"
                  "• 💬 دعم مباشر من أطباء وأخصائيي تغذية\n",
              style: theme.displayMedium?.copyWith(height: 1.6),
            ),

            //
            // _buildSectionTitle(context, "📞 تواصل معنا"),
            // Text(
            //   "📧 البريد الإلكتروني: support@dietpicnic.com\n"
            //       "📱 رقم التواصل: +20 100 000 0000\n"
            //       "📍 العنوان: القاهرة، مصر\n"
            //       "🌐 الموقع الإلكتروني: www.dietpicnic.com",
            //   style: theme.displayMedium?.copyWith(height: 1.6),
            // ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final theme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: theme.displayLarge?.copyWith(
          fontWeight: FontWeight.bold,
          
        ),
      ),
    );
  }
}
