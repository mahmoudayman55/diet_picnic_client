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
    fetchReviews();
  }

  Future<void> fetchOffers() async {
    if (offers.isNotEmpty) offers.clear();
    if (allSubOffers.isNotEmpty) allSubOffers.clear();
    isLoadingOffers.value = true;
    try {
      QuerySnapshot<Map<String, dynamic>> offersSnapshot;
      QuerySnapshot<Map<String, dynamic>> subSnapshot;
      try {
        offersSnapshot = await firestore.collection('offers').get(const GetOptions(source: Source.server));
        subSnapshot = await firestore.collection('sub_offers').get(const GetOptions(source: Source.server));
      } catch (_) {
        offersSnapshot = await firestore.collection('offers').get();
        subSnapshot = await firestore.collection('sub_offers').get();
      }

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
}
