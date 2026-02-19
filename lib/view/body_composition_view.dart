import 'package:diet_picnic_client/components/custom_app_bar.dart';
import 'package:diet_picnic_client/components/custom_text_form_field.dart';
import 'package:diet_picnic_client/components/custom_dropdown_widget.dart';
import 'package:diet_picnic_client/controller/body_composition_controller.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/core/theme.dart';
import 'package:diet_picnic_client/models/body_composition_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BodyCompositionView extends StatelessWidget {
  const BodyCompositionView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BodyCompositionController>(
      init: BodyCompositionController(),
      builder: (controller) {
        return Scaffold(
         //    backgroundColor: Themes.lightTheme.scaffoldBackgroundColor,
          appBar: CustomAppBar(
            title: 'صحتك في أرقام',
          ),
          body: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

             return SingleChildScrollView(
               padding: const EdgeInsets.all(16),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   // Header Section
                   _buildHeaderSection(),
                   
                   const SizedBox(height: 24),
                   
                   // Input Section
                   _buildInputSection(controller, context),
                   
                   const SizedBox(height: 24),
                   
                   // Calculate Button
                   _buildCalculateButton(controller,context),
                   
                   const SizedBox(height: 24),
                   
                   // Results Section
                   if (controller.showResults.value && controller.bodyCompositionResult.value != null)
                     _buildResultsSection(controller,context),
                   
                   const SizedBox(height: 24),
                   
                   // Action Buttons
                   _buildActionButtons(controller,context),
                 ],
               ),
             );
          }),
        );
      },
    );
  }

   Widget _buildHeaderSection() {
     return Container(
       width: double.infinity,
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(
         gradient: LinearGradient(
           colors: [
             CustomColors.mintBlue.withOpacity(0.3),
             CustomColors.mintBlue.withOpacity(0.1),
           ],
           begin: Alignment.topLeft,
           end: Alignment.bottomRight,
         ),
         borderRadius: BorderRadius.circular(12),
       ),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Row(
             children: [
               Container(
                 padding: const EdgeInsets.all(8),
                 decoration: BoxDecoration(
                   color: CustomColors.mintBlue,
                   borderRadius: BorderRadius.circular(8),
                 ),
                 child: const Icon(
                   Icons.favorite,
                   color: Colors.white,
                   size: 24,
                 ),
               ),
               const SizedBox(width: 12),
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(
                       'صحتك في أرقام',
                       style: Themes.lightTheme.textTheme.displayLarge?.copyWith(
                         fontWeight: FontWeight.bold,
                         color: CustomColors.mintBlue.withOpacity(0.8),
                       ),
                     ),
                     Text(
                       'احسب مؤشرات جسمك واكتشف حالتك الصحية',
                       style: Themes.lightTheme.textTheme.displayMedium?.copyWith(
                         color: CustomColors.mintBlue,
                       ),
                     ),
                   ],
                 ),
               ),
             ],
           ),
         ],
       ),
     );
   }

  Widget _buildInputSection(BodyCompositionController controller, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CustomColors.shadowLight,
        borderRadius: BorderRadius.circular(12),

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
             children: [
               Text(
                 'البيانات المطلوبة',
                 style: Theme.of(context).textTheme.displayLarge!.copyWith(fontWeight: FontWeight.bold)
               ),
               const SizedBox(width: 8),
               GestureDetector(
                 onTap: () => _showMeasurementInstructions(context),
                 child: Container(
                   padding: const EdgeInsets.all(6),
                   decoration: BoxDecoration(
                     color: CustomColors.mintBlue.withOpacity(0.1),
                     borderRadius: BorderRadius.circular(20),
                     border: Border.all(color: CustomColors.mintBlue.withOpacity(0.3)),
                   ),
                   child: Icon(
                     Icons.help_outline,
                     color: CustomColors.mintBlue,
                     size: 20,
                   ),
                 ),
               ),
             ],
           ),
          const SizedBox(height: 16),
          
   
          const SizedBox(height: 8),
          Obx(() => CustomDropdownWidget<String>(
            label: 'اختر الجنس',
            items: controller.genderOptions,
            selectedItem: controller.selectedGender.value,
            onChanged: controller.changeGender,
            color: Colors.grey,dark: true,
          )),
          
          const SizedBox(height: 16),
          
          // Height Input
          CustomTextFormField(
            context: context,
            controller: controller.heightController,
            label: 'الطول (سم)',
            hint: 'مثال: 170',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى إدخال الطول';
              }
              final height = double.tryParse(value);
              if (height == null || height <= 0) {
                return 'يرجى إدخال طول صحيح';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          // Weight Input
          CustomTextFormField(
            context: context,
            controller: controller.weightController,
            label: 'الوزن (كجم)',
            hint: 'مثال: 70',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى إدخال الوزن';
              }
              final weight = double.tryParse(value);
              if (weight == null || weight <= 0) {
                return 'يرجى إدخال وزن صحيح';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          // Waist Circumference Input
          CustomTextFormField(
            context: context,
            controller: controller.waistController,
            label: 'محيط الوسط (سم)',
            hint: 'مثال: 85',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى إدخال محيط الوسط';
              }
              final waist = double.tryParse(value);
              if (waist == null || waist <= 0) {
                return 'يرجى إدخال محيط خصر صحيح';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          // Hip Circumference Input
          CustomTextFormField(
            context: context,
            controller: controller.hipController,
            label: 'محيط الحوض (سم)',
            hint: 'مثال: 95',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'يرجى إدخال محيط الحوض';
              }
              final hip = double.tryParse(value);
              if (hip == null || hip <= 0) {
                return 'يرجى إدخال محيط ورك صحيح';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalculateButton(BodyCompositionController controller,BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Obx(() => ElevatedButton.icon(
        onPressed: controller.isCalculating.value ? null : controller.calculateBodyComposition,
        icon: controller.isCalculating.value 
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.calculate),
        label: Text(
          controller.isCalculating.value ? 'جاري الحساب...' : 'احسب المؤشرات',
          style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: CustomColors.mintBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
      )),
    );
  }

  Widget _buildResultsSection(BodyCompositionController controller,BuildContext context) {
    final result = controller.bodyCompositionResult.value!;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CustomColors.shadowLight,
        borderRadius: BorderRadius.circular(12),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.shade200,
        //     blurRadius: 8,
        //     offset: const Offset(0, 2),
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.analytics,
                color: Colors.green,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'النتائج',
                style: Themes.lightTheme.textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Ideal Body Weight
          _buildResultCard(context: context,
            icon: Icons.straighten,
            title: 'الوزن المثالي',
            value: '${result.idealBodyWeight.toStringAsFixed(1)} كجم',
            color: CustomColors.mintBlue,
          ),
          
          const SizedBox(height: 16),
          
          // BMI
          _buildResultCard(context: context,
            icon: Icons.monitor_weight,
            title: 'مؤشر كتلة الجسم (BMI)',
            value: '${result.bmi.toStringAsFixed(1)}',
            subtitle: result.bmiCategoryText,
            subtitleColor: Color(result.bmiCategoryColor),
            color: Colors.purple,
          ),
          
          const SizedBox(height: 16),
          
          // Waist Circumference
          _buildResultCard(context: context,
            icon: Icons.accessibility_new,
            title: 'محيط الوسط',
            value: '${result.waistCircumference.toStringAsFixed(1)} سم',
            subtitle: result.hasCentralObesity ? 'سمنة مركزية' : 'طبيعي (الدهون الحشوية)',
            subtitleColor: result.hasCentralObesity ? Colors.red : Colors.green,
            color: Colors.orange,
          ),
          
          const SizedBox(height: 16),
          
          // Waist-to-Hip Ratio
          _buildResultCard(context: context,
            icon: Icons.compare_arrows,
            title: 'نسبة الوسط إلى الحوض',
            value: '${result.waistToHipRatio.toStringAsFixed(2)}',
            subtitle: result.whrRiskLevelText,
            subtitleColor: Color(result.whrRiskLevelColor),
            color: Colors.teal,
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard({
    required IconData icon,
    required String title,
    required String value,
    String? subtitle,
    Color? subtitleColor,
    required Color color,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: Colors.white,
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
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w600,

                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Themes.lightTheme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (subtitleColor ?? Colors.grey).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      subtitle,
                      style: Themes.lightTheme.textTheme.displaySmall?.copyWith(
                        color: subtitleColor ?? Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BodyCompositionController controller,BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: controller.clearInputs,
            icon: const Icon(Icons.clear),
            label:  Text('مسح البيانات',style:  Theme.of(context).textTheme.displayMedium!.copyWith(color: Colors.red)),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: controller.resetResults,
            icon: const Icon(Icons.refresh),
            label:  Text('إعادة الحساب',style:  Theme.of(context).textTheme.displayMedium!.copyWith(color:CustomColors.mintBlue)),
            style: OutlinedButton.styleFrom(
              foregroundColor: CustomColors.mintBlue,
              side: const BorderSide(color: CustomColors.mintBlue),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showMeasurementInstructions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: CustomColors.mintBlue,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'تعليمات القياس الصحيح',
                          style: Themes.lightTheme.textTheme.displayLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Height Measurement
                        _buildInstructionSection(
                          icon: '🧍‍♂️',context: context,
                          title: 'أولاً: قياس الطول',
                          content: [
                            'الأدوات: مقياس طول (مسطرة حائطية أو شريط متر معدني مثبت على الحائط)',
                            '',
                            'الخطوات:',
                            '1. قف حافي القدمين على أرضية مستوية ملاصقة للحائط',
                            '2. تأكد أن الكعبين، والمؤخرة، والكتفين، ومؤخرة الرأس تلامس الحائط',
                            '3. اجعل نظرك للأمام في مستوى أفقي (لا تنظر لأعلى أو أسفل)',
                            '4. استخدم مسطرة أو أداة مستقيمة توضع فوق الرأس بشكل أفقي حتى تلامس الحائط',
                            '5. علّم النقطة على الحائط، ثم قِس المسافة من الأرض إلى العلامة بالسنتيمتر',
                            '',
                            '📏 نصيحة: يُفضل القياس في الصباح قبل النشاط اليومي، لأن الطول قد يقل قليلًا بنهاية اليوم',
                          ],
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Weight Measurement
                        _buildInstructionSection(
                          icon: '⚖️',context: context,
                          title: 'ثانيًا: قياس الوزن',
                          content: [
                            'الأدوات: ميزان رقمي أو ميكانيكي',
                            '',
                            'الخطوات:',
                            '1. ضع الميزان على سطح صلب ومستوي',
                            '2. قف على الميزان حافي القدمين دون حمل أي شيء',
                            '3. قف في المنتصف ووزّع وزنك بالتساوي على القدمين',
                            '4. سجّل الرقم الظاهر على الميزان بالكجم',
                            '',
                            '⚠️ نصيحة:',
                            '• قم بالقياس في نفس الوقت من اليوم (يفضل صباحًا بعد دخول الحمام وقبل الأكل)',
                            '• تجنّب القياس بعد وجبات أو تمرينات رياضية',
                          ],
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Waist Measurement
                        _buildInstructionSection(
                          icon: '📏',context: context,
                          title: 'ثالثًا: قياس محيط الوسط (Waist Circumference)',
                          content: [
                            'الأدوات: شريط قياس مرن (مثل شريط الخياطة - مازورة)',
                            '',
                            'الخطوات:',
                            '1. قف مستقيمًا وأخرج نفسك طبيعيًا (لا تشد البطن)',
                            '2. ضع الشريط حول البطن عند مستوى ٢ سم أعلى السرة (منتصف المسافة بين آخر ضلع وأعلى عظم الحوض)',
                            '3. تأكد أن الشريط مستوٍ وموازٍ للأرض وليس مشدودًا بشدة',
                            '4. سجّل القياس بالسنتيمتر',
                            '',
                            '⚠️ نصيحة:',
                            '• لا ترتدي ملابس سميكة أثناء القياس',
                            '• خذ القياس بعد الزفير الطبيعي',
                          ],
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Hip Measurement
                        _buildInstructionSection(
                          icon: '',context: context,
                          title: 'رابعًا: قياس محيط الحوض (Hip Circumference)',
                          content: [
                            'الأدوات: شريط قياس مرن (مثل شريط الخياطة - مازورة)',
                            '',
                            'الخطوات:',
                            '1. قف مستقيمًا وقدميك متقاربتين',
                            '2. ضع الشريط حول أوسع جزء من الأرداف والمؤخرة',
                            '3. تأكد أن الشريط أفقي وموازٍ للأرض',
                            '4. لا تشد الشريط بشدة، فقط ليكون ملاصقًا للجسم',
                            '5. سجّل الرقم بالسنتيمتر',
                          ],
                        ),
                        const SizedBox(height: 20),

                        Image.asset("assets/images/hip2.jpg"),
                        const SizedBox(height: 20),
                        Image.asset("assets/images/hip.jpg"),

                      ],
                    ),
                  ),
                ),
                
                // Close Button
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.mintBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'فهمت',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInstructionSection({
    required String icon,
    required String title,
    required List<String> content,
    required BuildContext context,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Themes.lightTheme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: CustomColors.mintBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...content.map((line) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              line,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(

                height: 1.4,
              ),
            ),
          )),
        ],
      ),
    );
  }
}
