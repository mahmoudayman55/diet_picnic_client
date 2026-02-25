import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_picnic_client/components/custom_snack_bar.dart';
import 'package:diet_picnic_client/models/offer_model.dart';
import 'package:diet_picnic_client/models/package_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class OfferPackagesController extends GetxController {

  @override
  void onInit() {
  offer = Get.arguments as OfferModel;
  getPackagesByIds();
    super.onInit();
  }
  /// Observables
  var isLoading = false.obs;
  var offerPackages = <PackageModel>[].obs;

  late OfferModel offer;

  /// 🟢 Get Packages by IDs
  Future<void> getPackagesByIds() async {
    try {
      isLoading.value = true;

      // IDs are derived from offer if not passed
      List<String> packageIds = offer.getPackageIds();
      offerPackages.clear();
      if (packageIds.isEmpty) {
        isLoading.value = false;
        return;
      }

      final firestore = FirebaseFirestore.instance;
      const int chunkSize = 10; // Firestore whereIn max limit
      final List<PackageModel> allFetchedPackages = [];

      for (var i = 0; i < packageIds.length; i += chunkSize) {
        final chunk = packageIds.sublist(
          i,
          i + chunkSize > packageIds.length ? packageIds.length : i + chunkSize,
        );

        final snapshot = await firestore
            .collection('packages')
            .where(FieldPath.documentId, whereIn: chunk)
            .get();

        final fetchedPackages = snapshot.docs
            .map((doc) => PackageModel.fromJson(doc.data(), doc.id))
            .toList();

        allFetchedPackages.addAll(fetchedPackages);
      }

      // Filter unique packages by their ID
      final uniquePackages = {
        for (var pkg in allFetchedPackages) pkg.id: pkg
      }.values.toList();

      offerPackages.addAll(uniquePackages);
      offerPackages.sort((a, b) => a.order.compareTo(b.order));
      log(offerPackages.length.toString(), name: "OFFERSCHECK");
    } catch (e) {
      showCustomSnackbar(
        title: "خطأ",
        message: "فشل تحميل الباقات: $e",
        successful: false,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
