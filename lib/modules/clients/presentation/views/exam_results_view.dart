import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:gal/gal.dart';
import '../../../../components/custom_snack_bar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/custom_colors.dart';
import '../../../../core/app_constants.dart';
import '../../domain/entities/exam_entities.dart';
import '../../../../controller/user_controller.dart';

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
    //final int score =10;
    final int totalQuestions = args['totalQuestions'] ?? 0;
    final PrizeEntity? prize = args['prize'];
    // final PrizeEntity? prize = args['prize'] ??
    //     PrizeEntity(
    //       id: 'test_prize',
    //       title: 'خصم خاص من دايت بيكنك',
    //       image: '',
    //       minScore: 0,
    //       maxScore: 100,
    //       availability: ExamAvailability.all,
    //       packageIds: [],
    //     );
    final ExamEntity? exam = args['exam'];

    final bool hasWon = prize != null;
    final String clientName =
        UserController.to.currentUser.value?.name ?? 'Admin Test';
    final DateTime? submissionDate = args['date'];
    final DateTime now = submissionDate ?? DateTime.now();

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
                  child: _ModernCouponCard(
                    clientName: clientName,
                    prizeTitle: prize!.title,
                    examTitle: exam.title,
                    date: now,
                    totalQuestions: totalQuestions,
                    score: score,
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
                  "لقد فزت بجائزة: ${prize!.title}",
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

// ─── Modern Coupon Card ───────────────────────────────────────────────────────
class _ModernCouponCard extends StatelessWidget {
  final String clientName;
  final String prizeTitle;
  final String examTitle;
  final int totalQuestions;
  final int score;
  final DateTime date;

  const _ModernCouponCard({
    required this.clientName,
    required this.prizeTitle,
    required this.examTitle,
    required this.totalQuestions,
    required this.score,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    const Color brandPeach = CustomColors.mainColor;
    const Color brandDarkRose = CustomColors.purble;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [brandDarkRose, brandPeach],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: brandPeach.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Decorative shapes for a modern look
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -20,
              left: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo & Header
                  Image.asset(
                    AppConstants.appLogo,
                    height: 50,
                  ),
                  const SizedBox(height: 24),

                  // Glass Section
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              examTitle,
                              style: textTheme.displayMedium?.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              totalQuestions > 0
                                  ? "$score / $totalQuestions"
                                  : "$score",
                              style: textTheme.displayLarge?.copyWith(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Divider(color: Colors.white24),
                            const SizedBox(height: 16),
                            Text(
                              'مُهدى إلى',
                              style: textTheme.displaySmall?.copyWith(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              clientName,
                              style: textTheme.headlineLarge?.copyWith(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Prize Section (Glassified)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Text(
                          prizeTitle,
                          style: textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tear-off line
                  Row(
                    children: [
                      _CircleNotch(isLeft: true),
                      Expanded(
                        child: DashedLine(color: Colors.white38),
                      ),
                      _CircleNotch(isLeft: false),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Footer / Date
                  Text(
                    '${date.day}/${date.month}/${date.year}',
                    style: textTheme.displaySmall?.copyWith(
                      color: Colors.white60,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'صالح لمدة شهر من تاريخه • استخدام مرة واحدة فقط\nالحد الأدنى للاستخدام عند الاشتراك في باقة ٣ شهور',
                    style: textTheme.displaySmall?.copyWith(
                      color: Colors.white38,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleNotch extends StatelessWidget {
  final bool isLeft;
  const _CircleNotch({required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Colors.white, // This creates the "cut" effect against the white background of the page
        shape: BoxShape.circle,
      ),
    );
  }
}

// ─── Dashed Line Widget ────────────────────────────────────────────────────────
class DashedLine extends StatelessWidget {
  final Color color;

  const DashedLine({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      const dashWidth = 6.0;
      const dashGap = 4.0;
      final count = (constraints.maxWidth / (dashWidth + dashGap)).floor();
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          count,
          (_) => Container(
            width: dashWidth,
            height: 1,
            margin: const EdgeInsets.only(right: dashGap),
            color: color,
          ),
        ),
      );
    });
  }
}

