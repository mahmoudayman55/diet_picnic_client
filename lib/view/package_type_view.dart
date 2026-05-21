import 'dart:ui';
import 'package:diet_picnic_client/components/package_flip_card.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/core/constants/app_gradients.dart';
import 'package:diet_picnic_client/models/package_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/custom_app_bar.dart';
import '../components/package_horizontal_card.dart';
import '../components/subscription_dialog.dart';
import '../controller/home_controller.dart';
import '../controller/package_type_controller.dart';
import '../core/custom_colors.dart';

class PackageTypeView extends StatefulWidget {
  const PackageTypeView({super.key});

  @override
  State<PackageTypeView> createState() => _PackageTypeViewState();
}

class _PackageTypeViewState extends State<PackageTypeView> {
  final PageController _pageController = PageController(viewportFraction: 0.85);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PackageTypeController>();
    final homeController = Get.find<HomeController>();
    final String title = controller.title;
    final size = MediaQuery.of(context).size;
    final screenW = size.width;
    final screenH = size.height;

    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: Obx(() {
        // Show full screen loading only if we don't have packages yet
        if (controller.isLoadingPackages.value &&
            controller.packages.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final packages = controller.packages;

        if (packages.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                controller.fetchPackages(),
                homeController.fetchOffers(),
              ]);
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: screenH * 0.7,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined,
                            size: screenW * 0.14, color: Colors.grey.shade400),
                        SizedBox(height: screenH * 0.02),
                        Text(
                          "لا توجد باقات متوفرة لهذا النوع حالياً",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // Get sub-offers for the current package from allSubOffers
        // (includes suboffers from unavailable offers too)
        final currentPackage = packages[
            controller.currentIndex.value.clamp(0, packages.length - 1)];
        final relatedSubOffers = homeController.allSubOffers
            .where((sub) => sub.packageId == currentPackage.id && sub.isVisible)
            .toList()
          ..sort((a, b) => a.order.compareTo(b.order));

        return RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              controller.fetchPackages(),
              homeController.fetchOffers(),
            ]);
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: true,
                child: Column(
                  children: [
                    // ── Package flip cards (6% of screen height) ──────────
                    SizedBox(
                      height: screenH * 0.6,
                      child: PageView.builder(
                        controller: _pageController,
                        physics: const BouncingScrollPhysics(),
                        onPageChanged: (index) {
                          controller.currentIndex.value = index;
                        },
                        itemCount: packages.length,
                        itemBuilder: (context, index) {
                          final pkg = packages[index];
                          final List<Color> gradient =
                              AppGradients.getGradient(pkg.gradientIndex);

                          return AnimatedBuilder(
                            animation: _pageController,
                            builder: (context, child) {
                              double value = 1.0;
                              if (_pageController.position.haveDimensions) {
                                value = _pageController.page! - index;
                                value =
                                    (1 - (value.abs() * 0.1)).clamp(0.8, 1.0);
                              } else if (index != 0) {
                                value = 0.9;
                              }
                              return Transform.scale(
                                scale: value,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenW * 0.01,
                                      vertical: screenH * 0.012),
                                  child: PackageFlipCard(
                                    title: pkg.name,
                                    target: pkg.target,
                                    smallDesc: pkg.about,
                                    fullDesc: pkg.description,
                                    gradient: gradient,
                                    onAction: () => Get.toNamed(
                                      AppConstants.packageDetailsPage,
                                      arguments: {"package_id": pkg.id},
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                    if (relatedSubOffers.isNotEmpty) ...[
                      SizedBox(height: screenH * 0.018),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: screenW * 0.05),
                        child: Row(
                          children: [
                            Text(
                              "العروض المتاحة",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenW * 0.025,
                                  vertical: screenH * 0.004),
                              decoration: BoxDecoration(
                                color: AppGradients.getGradient(currentPackage.gradientIndex)[1],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${relatedSubOffers.length} عرض",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenH * 0.012),
                      SizedBox(
                        height: screenH * 0.135,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding:
                              EdgeInsets.symmetric(horizontal: screenW * 0.04),
                          itemCount: relatedSubOffers.length,
                          itemBuilder: (context, index) {
                            final sub = relatedSubOffers[index];
                            final List<Color> packageGradient =
                                AppGradients.getGradient(currentPackage.gradientIndex);
                            return buildSubOfferCard(context, sub,
                                packageGradient, screenW, screenH);
                          },
                        ),
                      ),
                    ],
                    SizedBox(height: screenH * 0.02),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

Widget buildSubOfferCard(
  BuildContext context,
  dynamic sub,
  List<Color> gradient,
  double screenW,
  double screenH,
) {
  final bool hasOffer = sub.newPrice != -1;
  final Color bg = gradient[1];
  final textTheme = Theme.of(context).textTheme;

  return GestureDetector(
    onTap: () => SubscriptionDialog.show(context, sub.name, bg),
    child: Container(
      width: screenW * 0.42,
      margin: EdgeInsets.only(
          right: screenW * 0.03,
          bottom: screenH * 0.004,
          top: screenH * 0.004),
      decoration: BoxDecoration(
        // Dim the card slightly when there is no active offer
        color: bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: bg.withOpacity(hasOffer ? 0.25 : 0.12),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenW * 0.03, vertical: screenH * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ── Top badge ───────────────────────────────────────────────
            if (hasOffer)
              // Discount percentage badge
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: screenW * 0.02, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "وفر ${(100 - (sub.newPrice / sub.oldPrice * 100)).toInt()}%",
                  style: textTheme.labelSmall!.copyWith(
                    color: bg,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
              const SizedBox.shrink(),

            // ── Name ────────────────────────────────────────────────────
            Text(
              sub.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: (hasOffer
                      ? textTheme.displayMedium!
                      : textTheme.headlineMedium!)
                  .copyWith(
                color: hasOffer ? Colors.white : Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w600,
                height: 1.3,
              ),
            ),

            // ── Price row ────────────────────────────────────────────────
            if (hasOffer)
              // Offer active: show new price prominently + old price struck
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    "${sub.newPrice} EGP",
                    style: textTheme.displayLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: screenW * 0.015),
                  Text(
                    "${sub.oldPrice}",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: Colors.white70,
                      decorationThickness: 1.2,
                    ),
                  ),
                ],
              )
            else
              // No offer: show price cleanly without any strikethrough
              Text(
                "${sub.oldPrice} EGP",
                style: textTheme.headlineMedium!.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
