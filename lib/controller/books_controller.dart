import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_picnic_client/models/book_model.dart';
import 'package:get/get.dart';

class BooksController extends GetxController{
  var books = <BookModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<List<BookModel>> getBooks() async {
    final snapshot = await FirebaseFirestore.instance.collection('books').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return BookModel.fromJson(data, doc.id);
    }).toList();
  }
  @override
  void onInit() {
    super.onInit();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      books.value = await getBooks();
    } catch (e) {
      errorMessage.value = 'حدث خطأ أثناء جلب الكتب';
    } finally {
      isLoading.value = false;
    }
  }
}