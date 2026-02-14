import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

bool isValidPhoneNumber(String phone) {
  final normalized = phone.trim();
  final regex = RegExp(r'^\+?[0-9\s\-\(\)]{7,15}$');

  return regex.hasMatch(normalized);
}
Future<void> updateSubOffersOrderBasedOnLevel() async {
  final firestore = FirebaseFirestore.instance;

  try {
    final snapshot = await firestore.collection('sub_offers').get();

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final String? level = data['level'];

      int? order;

      switch (level) {
        case 'Vip':
          order = 1;
          break;
          case 'VIP':
          order = 1;
          break;
        case 'Elite':
          order = 2;
          break;
        case 'Super Elite':
          order = 3;
          break;
        default:
          order = null; // Skip unknown levels
      }

      if (order != null) {
        await firestore.collection('sub_offers').doc(doc.id).update({
          'order': order,
        });

        debugPrint('Updated ${doc.id} with order = $order');
      } else {
        debugPrint('Skipped ${doc.id}: Unknown level "$level"');
      }
    }

    debugPrint('All sub_offers updated successfully.');
  } catch (e) {
    debugPrint('Error updating sub_offers: $e');
  }
}
