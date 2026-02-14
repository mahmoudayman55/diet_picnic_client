import 'package:diet_picnic_client/components/animated_column.dart';
import 'package:diet_picnic_client/components/custom_app_bar.dart';
import 'package:diet_picnic_client/components/custom_cached_network_image.dart';
import 'package:diet_picnic_client/components/information_row.dart';
import 'package:diet_picnic_client/components/section_widget.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/view/quiz_view.dart';
import 'package:diet_picnic_client/view/update_personal_info_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

import 'package:diet_picnic_client/controller/user_controller.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/components/animated_column.dart';
import 'package:diet_picnic_client/components/section_widget.dart';
import 'package:diet_picnic_client/components/information_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart';

class UserProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    return Sizer(builder: (context, orientation, deviceType) {
      final width = 100.w;
      final heigh = 100.h;

      return Scaffold(
        appBar: AppBar(
          title: Text("حسابي", style: Theme.of(context).textTheme.headlineMedium),
        ),
        body: Obx(() {
          final user = userController.currentUser.value;

          if (user == null) {
            return const Center(child: Text("لم يتم تسجيل الدخول"));
          }

          // Helpers
          String _safe(String? value) =>
              (value != null && value.trim().isNotEmpty) ? value : "غير معروف";

          String _formatDate(DateTime? date) =>
              date != null ? DateFormat("dd/MM/yyyy").format(date) : "غير معروف";

          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: AnimatedColumn(
                children: [
                  SizedBox(
                    width: width,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: CustomColors.shadowLight,
                            blurRadius: 3,
                            spreadRadius: 2,
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            SizedBox(
                              width: width * 0.3,
                              height: width * 0.3,
                              child: ClipOval(
                                child:  CustomCachedNetworkImage(
                                  imageUrl: UserController.to.currentUser.value!.image ??
                                      AppConstants.dummyPerson1Image,fit: BoxFit.cover,

                                ),
                              ),
                            ),
                            SizedBox(
                              height: heigh * 0.03,
                            ),
                            Text(
                              UserController.to.currentUser.value!.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                            TextButton(
                              onPressed: () {
                                UserController.to.pickAndUploadProfileImage();
                              },
                              child: Text(
                                "تغيير الصورة الشخصية",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: CustomColors.mainColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SectionWidget(onTap: ()=>Get.to(UpdatePersonalInfoView()),
                    title: "معلوماتي الشخصية",
                    sideWidget: Icon(Icons.edit_outlined, color: CustomColors.textBlack54),
                    children: [
                      Divider(color: CustomColors.dividerLight),
                      InformationRow(leftText: "الإسم", rightText: _safe(user.name)),
                      InformationRow(
                          leftText: "تاريخ الميلاد", rightText: _formatDate(user.birthDate)),
                      InformationRow(leftText: "السن", rightText: user.birthDate != null ? "${user.age}" : "غير معروف"),
                      InformationRow(leftText: "رقم الهاتف", rightText: _safe(user.phone)),
                      InformationRow(leftText: "العنوان", rightText: _safe(user.address)),
                      InformationRow(leftText: "المؤهل", rightText: _safe(user.qualification)),
                      InformationRow(leftText: "الحالة الإجتماعية", rightText: _safe(user.socialStatus)),
                      InformationRow(leftText: "البريد الإلكتروني", rightText: _safe(user.email)),
                      InformationRow(leftText: "الطول", rightText: _safe(user.height != null && user.height!.isNotEmpty ? "${user.height} cm" : null)),
                      InformationRow(leftText: "النوع", rightText: _safe(user.gender)),
                    ],
                  ),
                  SizedBox(height: heigh * 0.03),
                  SectionWidget(onTap: ()=>Get.to(NewCustomerQuestionnaireQuizView()),
                    title: "التاريخ الطبى",
                    children: [
                      Divider(color: CustomColors.dividerLight),
                      InformationRow(
                        leftText: "حمل",
                        rightText: user.questionnaireAnswers == null
                            ? "غير معروف"
                            : (user.isPregnant! ? "نعم" : "لا"),
                      ),
                      InformationRow(
                        leftText: "رضاعة",
                        rightText: user.questionnaireAnswers == null
                            ? "غير معروف"
                            : (user.isLactating! ? "نعم" : "لا"),
                      ),

                      InformationRow(
                        leftText: "أمراض مزمنة",
                        rightText: (user.questionnaireAnswers?.chronicDiseases.isNotEmpty ?? false)
                            ? user.questionnaireAnswers!.chronicDiseases.join(", ")
                            : "غير معروف",
                      ),
                      InformationRow(
                        leftText: "أمراض عائلية مزمنة",
                        rightText: (user.questionnaireAnswers?.familyChronicDiseases.isNotEmpty ?? false)
                            ? user.questionnaireAnswers!.familyChronicDiseases.join(", ")
                            : "غير معروف",
                      ),
                      InformationRow(
                        leftText: "عمليات جراحية",
                        rightText: user.questionnaireAnswers?.hadSurgery == null
                            ? "غير معروف"
                            : (user.questionnaireAnswers!.hadSurgery ? "نعم" : "لا"),
                      ),


                      InformationRow(
                        leftText: "إصابات سابقة",
                        rightText: (user.questionnaireAnswers?.injuries.isNotEmpty ?? false)
                            ? user.questionnaireAnswers!.injuries.join(", ")
                            : "غير معروف",
                      ),
                      InformationRow(
                        leftText: "أدوية أو مكملات",
                        rightText: (user.questionnaireAnswers?.medications.isNotEmpty ?? false)
                            ? user.questionnaireAnswers!.medications.join(", ")
                            : "غير معروف",
                      ),
                      InformationRow(
                        leftText: "جوع عاطفى",
                        rightText: _safe(user.questionnaireAnswers?.emotionalHanger),
                      ),
                      InformationRow(
                        leftText: "تغير مفاجئ في الوزن",
                        rightText: _safe(user.questionnaireAnswers?.weightChange),
                      ),
                    ],
                    sideWidget: Icon(Icons.edit_outlined, color: CustomColors.textBlack54),
                  ),
                  SizedBox(height: heigh * 0.03),
                  SectionWidget(onTap: ()=>Get.to(NewCustomerQuestionnaireQuizView()),
                    title: "معلومات عامة",
                    children: [
                      Divider(color: CustomColors.dividerLight),
                      InformationRow(
                        leftText: "أدوات رياضية بالمنزل",
                        rightText: user.questionnaireAnswers == null
                            ? "غير معروف"
                            : (user.questionnaireAnswers!.homeEquipment.isNotEmpty
                            ? user.questionnaireAnswers!.homeEquipment.join(", ")
                            : "لا يوجد"),
                      ),


                      InformationRow(
                          leftText: "مقدار شرب الماء",
                          rightText: user.questionnaireAnswers?.waterIntake != null
                              ? "${user.questionnaireAnswers!.waterIntake} أكواب"
                              : "غير معروف"),
                      InformationRow(
                          leftText: "النشاط البدنى",
                          rightText: _safe(user.questionnaireAnswers?.activityLevel)),
                    ],
                    sideWidget: Icon(Icons.edit_outlined, color: CustomColors.textBlack54),
                  ),
                ],
              ),
            ),
          );
        }),
      );
    });
  }
}
