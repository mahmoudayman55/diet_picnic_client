import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_constants.dart';
import '../core/custom_colors.dart';

class SubscriptionDialog {
  static void show(BuildContext context, String offerName, Color themeColor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with Gradient
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [themeColor, themeColor.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: const Column(
                children: [
                  Icon(Icons.payment_rounded, color: Colors.white, size: 40),
                  SizedBox(height: 8),
                  Text(
                    "خطوات الاشتراك",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "يمكنك التحويل عبر الوسائل التالية:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPaymentOption(
                        "فودافون كاش",
                        "assets/images/voda.png",
                        () {
                          Clipboard.setData(const ClipboardData(text: "01011442231"));
                          Get.snackbar(
                            "تم النسخ",
                            "تم نسخ رقم فودافون كاش 01011442231 بنجاح ✅",
                            backgroundColor: Colors.green.withOpacity(0.9),
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                            margin: const EdgeInsets.all(15),
                            borderRadius: 15,
                            duration: const Duration(seconds: 2),
                            icon: const Icon(Icons.copy_all, color: Colors.white),
                          );
                        },
                      ),
                      _buildPaymentOption(
                        "InstaPay",
                        "assets/images/InstaPay.png",
                        () async {
                          final Uri url = Uri.parse("https://ipn.eg/S/ayman_elezzawy/instapay/82qfDJ");
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          } else {
                            Get.snackbar(
                              "خطأ",
                              "لا يمكن فتح رابط InstaPay",
                              backgroundColor: Colors.red.withOpacity(0.8),
                              colorText: Colors.white,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "اتبع الخطوات التالية:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildStep(1, "حول المبلغ المطلوب عبر إحدى الوسائل المتاحة.", themeColor),
                  _buildStep(2, "أرسل صورة التحويل (سكرين شوت) إلى واتساب رقم: ${AppConstants.phoneNumber} مع ذكر اسم العرض ($offerName).", themeColor),
                  _buildStep(3, "ابدأ بتغيير حياتك مع دايت بيكنك!", themeColor),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _launchWhatsApp(offerName),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.message),
                      label: const Text(
                        "تواصل عبر واتساب",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildPaymentOption(String name, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(color: Colors.grey.shade100),
            ),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'Tajawal',
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildStep(int number, String text, Color themeColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: themeColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              "$number",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void _launchWhatsApp(String offerName) async {
    final String message = "مرحباً، أريد الاشتراك في عرض: $offerName";
    final Uri url = Uri.parse(
      "whatsapp://send?phone=${AppConstants.phoneNumber}&text=${Uri.encodeComponent(message)}",
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Get.snackbar(
        "تنبيه",
        "تطبيق الواتساب غير مثبت على جهازك",
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
}
