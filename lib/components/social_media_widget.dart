import 'package:diet_picnic_client/components/custom_url_luncher.dart';
import 'package:diet_picnic_client/components/section_widget.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaSection extends StatelessWidget {
  const SocialMediaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWidget(
      title: "تواصل معنا",
      color: const Color(0xFFFAFAFB),
      elevation: 0,
      children: [
        SizedBox(width: double.infinity,
          child: Wrap(crossAxisAlignment: WrapCrossAlignment.center,alignment: WrapAlignment.center,

            children: [
              _socialButton(
                asset: "assets/images/facebook.png",
                color: Colors.blue,
                onTap: () async {
                  final url = Uri.parse("https://www.facebook.com/dietpicnicmain");
                  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                  throw 'لا يمكن فتح الرابط $url';
                  }
                  },
              ),
              _socialButton(
                asset: "assets/images/insta.png",
                color: Colors.pink,
                onTap: ()async {
                  final url = Uri.parse("https://www.instagram.com/diet_picnic3");
                  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                  throw 'لا يمكن فتح الرابط $url';
                  }
                },
              ),        _socialButton(
                asset: "assets/images/telegram.png",
                color: Colors.blue,
                onTap: ()async {
                  final url = Uri.parse("https://t.me/dietpicnic_channel");
                  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                  throw 'لا يمكن فتح الرابط $url';
                  }
                },
              ),
              // _socialButton(
              //   asset: "assets/images/ticktok.png",
              //   color: Colors.black54,
              //   onTap: () {
              //     // افتح رابط يوتيوب
              //   },
              // ),
              // _socialButton(
              //   asset: "assets/images/snap.png",
              //   color: Colors.yellow,
              //   onTap: () {
              //     // افتح رابط واتساب
              //   },
              // ),  _socialButton(
              //   asset: "assets/images/youtube.png",
              //   color: Colors.red,
              //   onTap: () {
              //     // افتح رابط واتساب
              //   },
              // ),

              _socialButton(
                asset: "assets/images/whatsapp.png",
                color: Colors.green,
                onTap: () {
                 CustomUrlLauncher.launchWhatsApp(phoneNumber: AppConstants.phoneNumber, message: "");
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _socialButton({
    required String asset,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(margin: EdgeInsets.all(8),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(asset, fit: BoxFit.contain),
        ),
      ),
    );
  }
}
