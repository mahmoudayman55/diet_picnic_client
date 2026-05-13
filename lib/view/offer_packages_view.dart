import 'package:diet_picnic_client/components/custom_app_bar.dart';
import 'package:diet_picnic_client/components/package_flip_card.dart';
import 'package:diet_picnic_client/components/subscription_dialog.dart';
import 'package:diet_picnic_client/controller/home_controller.dart';
import 'package:diet_picnic_client/controller/offer_packages_controller.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/view/package_type_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OfferPackagesView extends StatefulWidget {
  const OfferPackagesView({super.key});

  @override
  State<OfferPackagesView> createState() => _OfferPackagesViewState();
}

class _OfferPackagesViewState extends State<OfferPackagesView> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  final RxInt _currentIndex = 0.obs;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OfferPackagesController>();
    final homeController = Get.find<HomeController>();
    final size = MediaQuery.of(context).size;
    final double screenW = size.width;
    final double screenH = size.height;

    return Scaffold(
      appBar: CustomAppBar(title: controller.offer.name),
      body: Obx(() {
        // Full-screen loading while packages are being fetched
        if (controller.isLoading.value && controller.offerPackages.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final packages = controller.offerPackages;

        // Empty state
        if (packages.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async => controller.getPackagesByIds(),
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
                          "لا توجد باقات متاحة في هذا العرض حالياً",
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

        // Current package based on page index
        final currentPackage =
            packages[_currentIndex.value.clamp(0, packages.length - 1)];

        // Sub-offers for the current package (visible only, any parent offer)
        final relatedSubOffers = homeController.allSubOffers
            .where((sub) =>
                sub.packageId == currentPackage.id && sub.isVisible)
            .toList();

        return RefreshIndicator(
          onRefresh: () async => controller.getPackagesByIds(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: true,
                child: Column(
                  children: [
                    // ── Package flip cards (60% of screen height) ──────────
                    SizedBox(
                      height: screenH * 0.6,
                      child: PageView.builder(
                        controller: _pageController,
                        physics: const BouncingScrollPhysics(),
                        onPageChanged: (index) {
                          _currentIndex.value = index;
                        },
                        itemCount: packages.length,
                        itemBuilder: (context, index) {
                          final pkg = packages[index];
                          final List<Color> gradient =
                              CustomColors.packageGradients[
                                  index % CustomColors.packageGradients.length];

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
                                      horizontal: screenW * 0.025,
                                      vertical: screenH * 0.012),
                                  child: PackageFlipCard(
                                    title: pkg.name,
                                    target: pkg.target,
                                    smallDesc: pkg.about,
                                    fullDesc: pkg.description,
                                    gradient: gradient,
                                    onAction: () => Get.toNamed(
                                      AppConstants.packageDetailsPage,
                                      arguments: {
                                        "package_id": pkg.id,
                                        "offer_id": controller.offer.id,
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    // ── Sub-offer cards section ─────────────────────────
                    if (relatedSubOffers.isNotEmpty) ...[
                      SizedBox(height: screenH * 0.018),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenW * 0.05),
                        child: Row(
                          children: [
                            Text(
                              "العروض المتاحة",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenW * 0.025,
                                  vertical: screenH * 0.004),
                              decoration: BoxDecoration(
                                color: CustomColors.mainColor
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${relatedSubOffers.length} عرض",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                      color: CustomColors.mainColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenH * 0.012),
                      SizedBox(
                        height: screenH * 0.12,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: screenW * 0.04),
                          itemCount: relatedSubOffers.length,
                          itemBuilder: (context, index) {
                            final sub = relatedSubOffers[index];
                            final List<Color> packageGradient =
                                CustomColors.packageGradients[_currentIndex.value % CustomColors.packageGradients.length];
                            return buildSubOfferCard(
                                context, sub, packageGradient, screenW, screenH);
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
