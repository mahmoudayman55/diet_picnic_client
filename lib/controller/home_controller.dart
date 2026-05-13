import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:diet_picnic_client/components/custom_snack_bar.dart';
import 'package:diet_picnic_client/controller/app_update_controller.dart';
import 'package:diet_picnic_client/controller/user_controller.dart';
import 'package:diet_picnic_client/core/default_password_script.dart';
import 'package:diet_picnic_client/models/offer_model.dart';
import 'package:diet_picnic_client/models/package_model.dart';
import 'package:diet_picnic_client/models/review_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var offers = <OfferModel>[].obs;
  var allSubOffers = <SubOffer>[].obs;
  var isLoadingOffers = false.obs;
  var isLoadingPackages = false.obs;
  OfferModel? offer;

  /// قائمة الريفيوهات
  RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  var isLoadingReviews = false.obs;

  /// تحميل كل التقييمات من Firebase
  Future<void> fetchReviews() async {
    try {
      isLoadingReviews.value = true;

      // Fetch all reviews first
      final snapshot = await firestore.collection('reviews').get();

      if (snapshot.docs.isEmpty) {
        reviews.clear();
        return;
      }

      // Convert to models
      final allReviews = snapshot.docs
          .map((doc) => ReviewModel.fromJson(doc.data(), doc.id))
          .toList();

      // Shuffle and take 5 random reviews
      allReviews.shuffle();
      reviews.value = allReviews.take(5).toList();
    } catch (e) {
      showCustomSnackbar(
        title: 'خطأ',
        message: 'تعذر تحميل التقييمات: $e',
        successful: false,
      );
    } finally {
      isLoadingReviews.value = false;
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    UserController.to.restoreUser();
    fetchOffers();
    fetchPackages();
    fetchReviews();
  }

  Future<void> fetchOffers() async {
    if (offers.isNotEmpty) offers.clear();
    if (allSubOffers.isNotEmpty) allSubOffers.clear();
    isLoadingOffers.value = true;
    try {
      // جلب كل العروض (بدون فلتر isAvailable) لضمان جلب subOffers الخاصة بالعروض غير المتاحة
      final offersSnapshot = await firestore.collection('offers').get();

      // جلب كل الـ sub_offers مرة واحدة
      final subSnapshot = await firestore.collection('sub_offers').get();

      List<OfferModel> loadedOffers = [];
      List<SubOffer> loadedAllSubOffers = [];

      for (var doc in offersSnapshot.docs) {
        final data = doc.data();
        final offerId = doc.id;
        final offerName = data['name'] ?? '';
        final isAvailable = data['isAvailable'] == true;

        // جلب الـ subOffers الخاصة بهذا العرض
        final subOffers = subSnapshot.docs
            .where((subDoc) => subDoc.data()['offer_id'] == offerId)
            .map((subDoc) => SubOffer.fromJson(subDoc.data(), offerName))
            .toList();

        // أضف كل الـ subOffers لـ allSubOffers بغض النظر عن isAvailable
        loadedAllSubOffers.addAll(subOffers);

        // أضف فقط العروض المتاحة لقائمة العروض المعروضة في الهوم
        if (isAvailable) {
          loadedOffers.add(
            OfferModel(
              id: offerId,
              name: offerName,
              coverImage: data['cover_image'] ?? '',
              subOffers: subOffers,
              isAvailable: true,
              order: data['order'] ?? 0,
            ),
          );
        }
      }

      allSubOffers.value = loadedAllSubOffers;
      offers.value = loadedOffers;
      offers.value.sort((a, b) => a.order.compareTo(b.order));
      if (offers.isNotEmpty) {
        log(offers.value[0].order.toString(), name: "offerTest");
        log(offers.value[0].name.toString(), name: "offerTest");
      }
    } catch (e) {
      showCustomSnackbar(
        title: "خطأ",
        message: "حدث خطأ أثناء جلب العروض: $e",
        successful: false,
      );
    } finally {
      isLoadingOffers.value = false;
    }
  }

  /// القائمة اللي هتخزن فيها كل الباقات
  var packages = <PackageModel>[].obs;

  /// دالة جلب الباقات مع الجروبات الخاصة بيها
  Future<void> fetchPackages() async {
    log("getting packages");
    try {
      isLoadingPackages.value = true;
      if (packages.isNotEmpty) {
        packages.clear();
      }

      final snapshot = await firestore
          .collection('packages')
          .where('isAvailable', isEqualTo: true)
          .get();

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final packageId = doc.id;

        // 🟢 هات الجروبات المرتبطة بالباقة
        final groupSnapshot = await firestore
            .collection('groups')
            .where('packageId', isEqualTo: packageId)
            .get();

        final List<PackageGroup> groups = groupSnapshot.docs.map((groupDoc) {
          final groupData = groupDoc.data();
          return PackageGroup.fromJson(groupData);
        }).toList();

        // 🟢 كون الباقة مع الجروبات
        final package = PackageModel.fromJson(data, packageId)..groups = groups;
        packages.add(package);
      }
      packages.value.sort((a, b) => a.order.compareTo(b.order));
    } catch (e) {
      showCustomSnackbar(
        title: "خطأ",
        message: "فشل في جلب الباقات: $e",
        successful: false,
      );
    } finally {
      isLoadingPackages.value = false;
    }
  }
}
