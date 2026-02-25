import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:gal/gal.dart';
import '../../../../components/custom_snack_bar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/custom_colors.dart';
import '../../domain/entities/exam_entities.dart';
import '../../../../controller/user_controller.dart';
import '../../../../components/custom_cached_network_image.dart';

class ExamResultsView extends StatefulWidget {
  const ExamResultsView({super.key});

  @override
  State<ExamResultsView> createState() => _ExamResultsViewState();
}

class _ExamResultsViewState extends State<ExamResultsView> {
  final GlobalKey _boundaryKey = GlobalKey();
  bool _isCapturing = false;

  Future<Uint8List?> _captureAsImage() async {
    try {
      RenderRepaintBoundary? boundary = _boundaryKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;

      // Ensure the image is fully loaded before capturing
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint("Error capturing image: $e");
      return null;
    }
  }

  Future<void> _saveCertificate() async {
    setState(() => _isCapturing = true);
    try {
      final imageBytes = await _captureAsImage();
      if (imageBytes != null) {
        final tempDir = await getTemporaryDirectory();
        final file = await File(
                '${tempDir.path}/certificate_${DateTime.now().millisecondsSinceEpoch}.png')
            .create();
        await file.writeAsBytes(imageBytes);

        await Gal.putImage(file.path);
        showCustomSnackbar(
          title: "نجاح",
          message: "تم حفظ الجائزة في المعرض بنجاح",
          successful: true,
        );
      }
    } catch (e) {
      debugPrint("Error saving image: $e");
      showCustomSnackbar(
        title: "خطأ",
        message: "حدث خطأ أثناء حفظ الجائزة: $e",
        successful: false,
      );
    } finally {
      setState(() => _isCapturing = false);
    }
  }

  Future<void> _shareCertificate() async {
    setState(() => _isCapturing = true);
    try {
      final imageBytes = await _captureAsImage();
      if (imageBytes != null) {
        final tempDir = await getTemporaryDirectory();
        final file = await File(
                '${tempDir.path}/certificate_${DateTime.now().millisecondsSinceEpoch}.png')
            .create();
        await file.writeAsBytes(imageBytes);

        await Share.shareXFiles([XFile(file.path)],
            text: 'لقد فزت بجائزة من دايت بيكنك! 🎉');
      }
    } catch (e) {
      debugPrint("Error sharing image: $e");
    } finally {
      setState(() => _isCapturing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments ?? {};
    final int score = args['score'] ?? 0;
    final int totalQuestions = args['totalQuestions'] ?? 0;
    final PrizeEntity? prize = args['prize'];
    final ExamEntity? exam = args['exam'];

    final bool hasWon = prize != null;
    final String clientName =
        UserController.to.currentUser.value?.name ?? 'Admin Test';
    final DateTime now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "نتائج الاختبار",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                hasWon ? "تهانينا! 🎉" : "انتهى الاختبار",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: CustomColors.selectedNavBarColor,
                      fontSize: 32,
                    ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: CustomColors.selectedNavBarColor,
                    width: 4,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      totalQuestions > 0
                          ? "$score / $totalQuestions"
                          : "$score",
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      "درجتك",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              if (hasWon && exam != null) ...[
                RepaintBoundary(
                  key: _boundaryKey,
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 250),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          // Background Image
                          CustomCachedNetworkImage(
                            imageUrl: exam.prizeImage,
                          ),
                          // Details Overlay
                          Positioned.fill(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Exam Title
                                Text(
                                  exam.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                        color: Colors.blueGrey.shade800,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                // Client Name
                                Text(
                                  clientName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                        color:
                                            const Color(0xFFB71C1C), // Deep Red
                                        fontSize: 26,
                                        fontWeight: FontWeight.w900,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                // Prize in Yellow Banner
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.yellow.shade400,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                                  ),
                                  child: Text(
                                    prize.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                          color: const Color(0xFF424242),
                                          fontWeight: FontWeight.bold,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            bottom: 40,
                            left: 0,
                            child: Align(
                              alignment: AlignmentGeometry.bottomLeft,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '\nهذا الكوبون متاح لمدة شهر من تاريخه\n استخدام الكوبون مرة واحدة فقط لحامله أو أحد معارفه\n مسموح باستخدام كوبون واحد فقط في المرة الواحدة\nالحد الأدني لاستخدامه عند الاشتراك في باقة ٣ شهور',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(
                                            color: Colors.grey.shade800,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${now.day}/${now.month}/${now.year}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(
                                            color: Colors.grey.shade600,
                                            fontSize: 10,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Action Buttons for Coupon
                if (_isCapturing)
                  const CircularProgressIndicator()
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _saveCertificate,
                          icon: const Icon(Icons.download, color: Colors.white),
                          label: Text(
                            "حفظ في المعرض",
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _shareCertificate,
                          icon: const Icon(Icons.share, color: Colors.white),
                          label: Text(
                            "مشاركة",
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.selectedNavBarColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
              ] else if (hasWon) ...[
                // Fallback if exam entity is missing for some reason
                Text(
                  "لقد فزت بجائزة: ${prize.title}",
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                Text(
                  "لم توفق فى الحصول على جائزة هذه المرة.",
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.selectedNavBarColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  onPressed: () => Get.back(),
                  child: Text(
                    "العودة للرئيسية",
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
