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
    final int totalQuestions = args['totalQuestions'] ?? 0;
    final PrizeEntity? prize = args['prize'];
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
                  child: _RamadanCouponCard(
                    clientName: clientName,
                    prizeTitle: prize.title,
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

// ─── Ramadan Coupon Card ───────────────────────────────────────────────────────
class _RamadanCouponCard extends StatelessWidget {
  final String clientName;
  final String prizeTitle;
  final String examTitle;
  final int totalQuestions;
  final int score;
  final DateTime date;

  const _RamadanCouponCard({
    required this.clientName,
    required this.prizeTitle,
    required this.examTitle,
    required this.totalQuestions,
    required this.score,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    const Color brandOrange = CustomColors.mainColor;
    const Color brandPurple = CustomColors.purble;
    const Color lightGold = Color(0xFFFFD500);
    const Color creamWhite = Color(0xFFFFFDE7);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [brandPurple, Color(0xFF7A3D56), brandPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: brandOrange, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: brandOrange.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            // ── Subtle geometric pattern overlay ──────────────────────────
            Positioned.fill(
              child: CustomPaint(
                painter: _IslamicPatternPainter(
                    color: brandOrange.withOpacity(0.07)),
              ),
            ),

            // ── Content ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Arched Header ──────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          brandOrange,
                          lightGold,
                          brandOrange,
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(60),
                        bottomRight: Radius.circular(60),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: brandOrange.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Stars + Crescent row
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('✦',
                                style: TextStyle(
                                    color: brandPurple, fontSize: 14)),
                            SizedBox(width: 6),
                            Text('🌙', style: TextStyle(fontSize: 22)),
                            SizedBox(width: 6),
                            Text('✦',
                                style: TextStyle(
                                    color: brandPurple, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'رمضان كريم',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                            color: brandPurple,
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            shadows: [
                              Shadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4),
                            ],
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'كوبون جائزة',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                color: brandPurple.withOpacity(0.85),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Logo ──
                  Image.asset(
                    AppConstants.appLogo,
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),

                  // const SizedBox(height: 6),
                  //
                  // // ── App Name label ──
                  // Text(
                  //   AppConstants.appName,
                  //   style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  //         color: lightGold,
                  //         fontWeight: FontWeight.w700,
                  //         fontSize: 13,
                  //         letterSpacing: 1.5,
                  //       ),
                  //   textDirection: TextDirection.rtl,
                  // ),

                  const SizedBox(height: 6),

                  // ── Exam title ─────────────────────────────────────────
                  Text(
                    examTitle,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.white,
                        ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),

                  const SizedBox(height: 12),
                  Text(
                    totalQuestions > 0 ? "$score / $totalQuestions" : "$score",
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  // ── Decorative divider ─────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                          child: Divider(
                              color: brandOrange.withOpacity(0.5),
                              thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text('✦',
                            style: TextStyle(color: brandOrange, fontSize: 12)),
                      ),
                      Expanded(
                          child: Divider(
                              color: brandOrange.withOpacity(0.5),
                              thickness: 1)),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ── Winner name ────────────────────────────────────────
                  Text(
                    'يُهدى إلى',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: brandOrange.withOpacity(0.8),
                          fontWeight: FontWeight.w600,
                        ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    clientName,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: lightGold,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),

                  const SizedBox(height: 16),

                  // ── Prize ribbon ───────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          brandOrange,
                          lightGold,
                          brandOrange,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: brandOrange.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Text(
                      prizeTitle,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: brandPurple,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ── Notched separator (mimics tear-off coupon edge) ────
                  Row(
                    children: [
                      const _SemiCircleCut(fromLeft: true),
                      Expanded(
                        child: DashedLine(color: brandOrange.withOpacity(0.5)),
                      ),
                      const _SemiCircleCut(fromLeft: false),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ── Terms ──────────────────────────────────────────────
                  Text(
                    'هذا الكوبون متاح لمدة شهر من تاريخه\nاستخدام الكوبون مرة واحدة فقط لحامله أو أحد معارفه\nمسموح باستخدام كوبون واحد فقط في المرة الواحدة\nالحد الأدنى لاستخدامه عند الاشتراك في باقة ٣ شهور',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: creamWhite.withOpacity(0.70),
                          fontSize: 9.5,
                          height: 1.7,
                        ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),

                  const SizedBox(height: 8),

                  // ── Date ───────────────────────────────────────────────
                  Text(
                    '${date.day}/${date.month}/${date.year}',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: brandOrange.withOpacity(0.7),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
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
        children: List.generate(
          count,
          (_) => Container(
            width: dashWidth,
            height: 1.5,
            margin: const EdgeInsets.only(right: dashGap),
            color: color,
          ),
        ),
      );
    });
  }
}

// ─── Semi-circle notch widget ─────────────────────────────────────────────────
class _SemiCircleCut extends StatelessWidget {
  final bool fromLeft;

  const _SemiCircleCut({required this.fromLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: CustomColors.mainColor,
        shape: BoxShape.circle,
        border: Border.all(
            color: CustomColors.mainColor.withOpacity(0.4), width: 1),
      ),
    );
  }
}

// ─── Islamic geometric pattern painter ───────────────────────────────────────
class _IslamicPatternPainter extends CustomPainter {
  final Color color;

  _IslamicPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final math.Random random = math.Random(42); // Seed for consistency
    const double step = 50.0;

    for (double y = 0; y < size.height; y += step) {
      for (double x = 0; x < size.width; x += step) {
        final String emoji = random.nextBool() ? '🌙' : '🏆';
        final textPainter = TextPainter(
          text: TextSpan(
            text: emoji,
            style: TextStyle(
              fontSize: 14,
              color: color.withOpacity(0.1), // Ensure it stays subtle
            ),
          ),
          textDirection: TextDirection.rtl,
        )..layout();

        final offset =
            Offset(x - textPainter.width / 2, y - textPainter.height / 2);
        textPainter.paint(canvas, offset);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
