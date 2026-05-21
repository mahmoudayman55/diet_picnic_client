import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_picnic_client/components/custom_snack_bar.dart';
import 'package:diet_picnic_client/models/package_model.dart';
import 'package:get/get.dart';

class PackageTypeController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late final String type;
  late final String title;
  var packages = <PackageModel>[].obs;
  var isLoadingPackages = false.obs;
  var currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    type = Get.arguments as String;
    title = type == 'group'
        ? 'التحديات الجماعية'
        : type == 'individual'
            ? 'المتابعات الفردية'
            : 'استشارة هاتفية';
    fetchPackages();
  }

  Future<void> fetchPackages() async {
    log("getting packages for type: $type");
    try {
      isLoadingPackages.value = true;
      packages.clear();
      currentIndex.value = 0;

      QuerySnapshot<Map<String, dynamic>> snapshot;
      try {
        snapshot = await firestore
            .collection('packages')
            .where('isAvailable', isEqualTo: true)
            .where('type', isEqualTo: type)
            .get(const GetOptions(source: Source.server));
      } catch (_) {
        snapshot = await firestore
            .collection('packages')
            .where('isAvailable', isEqualTo: true)
            .where('type', isEqualTo: type)
            .get();
      }

      final List<PackageModel> tempPackages = [];
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final packageId = doc.id;

        // 🟢 هات الجروبات المرتبطة بالباقة
        QuerySnapshot<Map<String, dynamic>> groupSnapshot;
        try {
          groupSnapshot = await firestore
              .collection('groups')
              .where('packageId', isEqualTo: packageId)
              .get(const GetOptions(source: Source.server));
        } catch (_) {
          groupSnapshot = await firestore
              .collection('groups')
              .where('packageId', isEqualTo: packageId)
              .get();
        }

        final List<PackageGroup> groups = groupSnapshot.docs.map((groupDoc) {
          final groupData = groupDoc.data();
          return PackageGroup.fromJson(groupData);
        }).toList();

        // 🟢 كون الباقة مع الجروبات
        final package = PackageModel.fromJson(data, packageId)..groups = groups;
        tempPackages.add(package);
      }
      tempPackages.sort((a, b) => a.order.compareTo(b.order));
      packages.assignAll(tempPackages);
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
