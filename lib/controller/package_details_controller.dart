import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_picnic_client/components/custom_snack_bar.dart';

import 'package:diet_picnic_client/models/offer_model.dart';
import 'package:diet_picnic_client/models/package_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';

class PackageDetailsController extends GetxController {
  final package = Rxn<PackageModel>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final isAddingGroup = false.obs;
  final validatingGroupMembers = false.obs;

  final isGroupsLoading = false.obs;
  final groupsError = ''.obs;

  late final String packageId;
   String? offerId;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var subOffers = <SubOffer>[].obs;

  Future<void> fetchSubOffersByPackageId(String packageId,String? offerId) async {
    try {
      
   
        final snapshot =offerId==null? await firestore
            .collection('sub_offers')
            .where('package_id', isEqualTo: packageId)
            .get():await firestore
            .collection('sub_offers')
            .where('package_id', isEqualTo: packageId).where("offer_id",isEqualTo: offerId)
            .get();
 

      // ✅ Wait for all async operations to complete
      final fetchedSubOffers = await Future.wait(
        snapshot.docs.map((doc) async {
          final data = doc.data();
          final offerId = data['offer_id'];

          String offerName = "غير معروف";

          // ✅ Get related offer document name (no availability filter)
          if (offerId != null) {
            final offerDoc = await firestore.collection('offers').doc(offerId).get();
            final offerData = offerDoc.data();
            offerName = offerData?["name"] ?? "غير معروف";
          }

          // ✅ Return SubOffer (all sub-offers, regardless of parent offer availability)
          return SubOffer.fromJson(data, offerName);
        }),
      );

      // ✅ Keep only visible sub-offers (isVisible == true)
      final validSubOffers = fetchedSubOffers
          .whereType<SubOffer>()
          .where((sub) => sub.isVisible)
          .toList();

      subOffers.assignAll(validSubOffers);
      subOffers.sort((a, b) => a.order.compareTo(b.order));

    } catch (e) {
      showCustomSnackbar(
        title: "خطأ",
        message: "فشل تحميل العروض الفرعية: $e",
        successful: false,
      );
      subOffers.clear();
    }
  }


  @override
  Future<void> onInit() async {
    super.onInit();
    packageId = Get.arguments['package_id'] as String;
    offerId = Get.arguments['offer_id'];
    await loadPackage();
    fetchSubOffersByPackageId(packageId,offerId);
  }

  RxList<OfferModel> offers = <OfferModel>[].obs;

  Future<void> fetchOffersByPackageId() async {
    isLoading.value = true;
    try {
      final snapshot = await firestore
          .collection('sub_offers')
          .where('package_id', isEqualTo: packageId)
          .get();

      final fetchedOffers = snapshot.docs.map((doc) {
        final data = doc.data();
        return OfferModel.fromJson(data, doc.id);
      }).toList();

      offers.value = fetchedOffers;
      log(fetchedOffers.toString(), name: "OffersByPackage");
    } catch (e) {
      showCustomSnackbar(
        title: "خطأ",
        message: "فشل في تحميل العروض: $e",
        successful: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// 🟢 تحميل باقة محددة باستخدام الـ packageId
  Future<void> loadPackage() async {
    try {
      isLoading.value = true;
      final doc = await firestore.collection('packages').doc(packageId).get();

      if (doc.exists) {
        final data = doc.data()!;
        final pkg = PackageModel.fromJson(data, doc.id);

        // 🟢 هات الجروبات الخاصة بالباقة
        final groupSnapshot = await firestore
            .collection('groups')
            .where('packageId', isEqualTo: packageId)
            .get();

        final groups = groupSnapshot.docs.map((groupDoc) {
          return PackageGroup.fromJson(groupDoc.data());
        }).toList();

        pkg.groups = groups;

        package.value = pkg;
      } else {
        showCustomSnackbar(
          title: "خطأ",
          message: "الباقة غير موجودة",
          successful: false,
        );
      }
    } catch (e) {
      showCustomSnackbar(
        title: "خطأ",
        message: "فشل تحميل بيانات الباقة: $e",
        successful: false,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
