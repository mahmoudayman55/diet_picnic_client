import 'dart:ui';
import 'package:diet_picnic_client/components/package_flip_card.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/custom_app_bar.dart';
import '../components/package_horizontal_card.dart';
import '../components/subscription_dialog.dart';
import '../controller/home_controller.dart';
import '../core/custom_colors.dart';

class PackageTypeView extends StatefulWidget {
  const PackageTypeView({super.key});

  @override
  State<PackageTypeView> createState() => _PackageTypeViewState();
}

class _PackageTypeViewState extends State<PackageTypeView> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String type = Get.arguments as String;
    final String title = type == 'group'
        ? 'التحديات الجماعية'
        : type == 'individual'
            ? 'المتابعات الفردية'
            : 'استشارة هاتفية';

    final homeController = Get.find<HomeController>();

    return Scaffold(
      appBar: CustomAppBar(title: title),
      body: Obx(() {
        // Show full screen loading only if we don't have packages yet
        if (homeController.isLoadingPackages.value &&
            homeController.packages.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final filteredPackages =
            homeController.packages.where((p) => p.type == type).toList();

        if (filteredPackages.isEmpty) {
          return RefreshIndicator(
            onRefresh: () => homeController.fetchPackages(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined,
                            size: 60, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
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
        final currentPackage = filteredPackages[
            _currentIndex.clamp(0, filteredPackages.length - 1)];
        final relatedSubOffers = homeController.allSubOffers
            .where((sub) => sub.packageId == currentPackage.id && sub.isVisible)
            .toList();

        return RefreshIndicator(
          onRefresh: () => homeController.fetchPackages(),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: true,
                child: Column(
                  children: [
                    // const SizedBox(height: 20),
                    Expanded(
                      flex: 3,
                      child: PageView.builder(
                        controller: _pageController,
                        physics: const BouncingScrollPhysics(),
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemCount: filteredPackages.length,
                        itemBuilder: (context, index) {
                          final pkg = filteredPackages[index];
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
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
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            Text(
                              "العروض المتاحة",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: CustomColors.mainColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${relatedSubOffers.length} عرض",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .copyWith(
                                      color: CustomColors.mainColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: relatedSubOffers.length,
                          itemBuilder: (context, index) {
                            final sub = relatedSubOffers[index];
                            // Use current package gradient for the sub-offers
                            final List<Color> packageGradient =
                                CustomColors.packageGradients[_currentIndex %
                                    CustomColors.packageGradients.length];
                            return _buildSubOfferCard(
                                context, sub, packageGradient);
                          },
                        ),
                      ),
                    ],
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSubOfferCard(
      BuildContext context, dynamic sub, List<Color> gradient) {
    final Color backgroundColor = gradient.first;
    return GestureDetector(
      onTap: () => SubscriptionDialog.show(context, sub.level, backgroundColor),
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 12, bottom: 4, top: 4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "وفر ${(100 - (sub.newPrice / sub.oldPrice * 100)).toInt()}%",
                      style: Theme.of(context).textTheme.labelSmall!.copyWith(
                            color: backgroundColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                sub.name,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    "${sub.newPrice} EGP",
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${sub.oldPrice}",
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: Colors.white.withOpacity(0.5),
                          decoration: TextDecoration.lineThrough,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
