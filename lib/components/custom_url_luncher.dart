import 'package:diet_picnic_client/components/custom_snack_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomUrlLauncher {
  static void launchEmailApp(String email) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: email,
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch email app';
    }
  }

  static void launchCallApp(String phoneNumber) async {
    final Uri uri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw 'Could not launch call app';
    }
  }

  static void launchGoogleMaps(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  static Future<void> launchWebUrl(String url) async {
    try {
      // ✅ Normalize the URL
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        url = 'https://$url';
      }

      final uri = Uri.tryParse(url);

      if (uri == null) {
        customSnackBar(
          title: "خطأ",
          message: "الرابط غير صالح",
          successful: false,
        );
        return;
      }

      // ✅ Check if it can be launched
      final canLaunch = await canLaunchUrl(uri);
      if (!canLaunch) {
        customSnackBar(
          title: "خطأ",
          message: "لا يمكن فتح الرابط حالياً",
          successful: false,
        );
        return;
      }

      // ✅ Launch in external browser (Chrome / Safari)
      await launchUrl(
        uri,
        mode: LaunchMode.inAppBrowserView,
      );
    } catch (e) {
      // ✅ Handle unexpected issues (e.g., malformed URLs or missing browser)
      customSnackBar(
        title: "خطأ",
        message: "حدث خطأ أثناء فتح الرابط: ${e.toString()}",
        successful: false,
      );
    }
  }
 static Future<void> launchGoogleDriveFolder(String url) async {
    if (!url.startsWith('http')) {
      url = 'https://' + url;
    }

    // Make sure folder is shareable
    if (!url.contains('?usp=sharing')) {
      url += '?usp=sharing';
    }

    final uri = Uri.parse(url);

    try {
      // Directly launch in external browser
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Error launching Google Drive folder: $e');
    }
  }

  /// 🟢 فتح واتساب مع رسالة مبدئية
  static Future<void> launchWhatsApp({
    required String phoneNumber,
    required String message,
  }) async {
    // تنظيف الرقم
    String cleanedNumber = phoneNumber.trim();

    // لو بيبدأ بـ 0 → نشيلها ونضيف +20
    if (cleanedNumber.startsWith("0")) {
      cleanedNumber = "+20${cleanedNumber.substring(1)}";
    }
    // لو مش بيبدأ بـ + → نفترض أنه مصري ونضيف +20
    else if (!cleanedNumber.startsWith("+")) {
      cleanedNumber = "+20$cleanedNumber";
    }

    final Uri uri = Uri.parse(
        "https://wa.me/$cleanedNumber?text=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch WhatsApp';
    }
  }

}
