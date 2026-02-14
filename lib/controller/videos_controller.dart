import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_picnic_client/models/book_model.dart';
import 'package:diet_picnic_client/models/video_model.dart';
import 'package:get/get.dart';

class VideosController extends GetxController{
  var videos = <VideoModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<List<VideoModel>> getVideos() async {
    final snapshot = await FirebaseFirestore.instance.collection('videos').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return VideoModel.fromJson(data, doc.id);
    }).toList();
  }
  @override
  void onInit() {
    super.onInit();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      videos.value = await getVideos();
    } catch (e) {
      errorMessage.value = 'حدث خطأ أثناء جلب الكتب';
    } finally {
      isLoading.value = false;
    }
  }
}