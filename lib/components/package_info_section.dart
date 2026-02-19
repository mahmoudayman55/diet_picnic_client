
import 'package:diet_picnic_client/components/section_card.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/core/date_time_formater.dart';
import 'package:diet_picnic_client/models/client_profile_model.dart';
import 'package:flutter/material.dart';

class PackageInfoSection extends StatelessWidget {
  final ClientProfileModel client;

  const PackageInfoSection({Key? key, required this.client}) : super(key: key);

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF333333),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'غير محدد',
              style: TextStyle(
                color: value.isNotEmpty ? const Color(0xFFB76E79) : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'معلومات الباقة',
      icon: Icons.card_membership,
      children: [
        _buildInfoRow('الباقة', client.package!.name),
        _buildInfoRow(
            'المجموعة',
            client.packageGroup == null
                ? 'غير محدد'
                : client.packageGroup!.name),
        _buildInfoRow(
            'التصنيف', client.order!.isEmpty ? 'غير محدد' : client.order!),
        _buildInfoRow('الفئة', client.category!),
        // New: Subscription and Start Dates
        _buildInfoRow(
            'تاريخ الاشتراك',
            client.subscriptionDate != null
                ? DateTimeFormatter.dateTimeToFullDate(client.subscriptionDate!)
                : 'غير محدد'),
        _buildInfoRow(
            'تاريخ البداية',
            client.startDate != null
                ? DateTimeFormatter.dateTimeToFullDate(client.startDate!)
                : 'غير محدد'),
        _buildInfoRow('تاريخ التجديد',
            DateTimeFormatter.dateTimeToFullDate(client.renewalDate!)),
        _buildInfoRow('الوقت المتبقي', client.timeLeft),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: client.isExpired
                    ? Colors.red
                    : CustomColors.mintGold,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                client.isExpired ? 'منتهية' : 'نشطة',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {

              },
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color:  CustomColors.selectedNavBarColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "تجديد الإشتراك",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
