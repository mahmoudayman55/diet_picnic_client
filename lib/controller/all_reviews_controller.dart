import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_picnic_client/components/custom_snack_bar.dart';
import 'package:diet_picnic_client/models/review_model.dart';
import 'package:get/get.dart';

class AllReviewsController extends GetxController{
  @override
  void onInit() {
    fetchReviews();
    super.onInit();
  }
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// قائمة الريفيوهات
  RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  var isLoadingReviews = false.obs;
  /// تحميل كل التقييمات من Firebase
  Future<void> fetchReviews() async {
    try {
      isLoadingReviews.value = true;

      final snapshot = await firestore
          .collection('reviews')
          .orderBy('date', descending: true) // Most recent first
          .get();

      reviews.value = snapshot.docs
          .map((doc) => ReviewModel.fromJson(doc.data(), doc.id))
          .toList();

    } catch (e) {
      customSnackBar(
        title: 'خطأ',
        message: 'تعذر تحميل التقييمات: $e',
        successful: false,
      );
    } finally {
      isLoadingReviews.value = false;
    }
  }


}