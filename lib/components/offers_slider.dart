import 'dart:async';
import 'package:diet_picnic_client/components/offer_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';

class OffersSlider extends StatefulWidget {
  final double width;
  final double height;
  final List offers;

  const OffersSlider({
    Key? key,
    required this.width,
    required this.height,
    required this.offers,
  }) : super(key: key);

  @override
  State<OffersSlider> createState() => _OffersSliderState();
}

class _OffersSliderState extends State<OffersSlider> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  // 🔴 عدد كبير جداً للـ infinite scroll
  static const int _initialPage = 10000;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
    _currentPage = _initialPage;

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients || widget.offers.isEmpty) return;

      _currentPage++;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.offers.isEmpty) return const SizedBox();

    return Column(
      children: [
        SizedBox(
          height: widget.height * 0.3,
          width: widget.width,
          child: PageView.builder(
            controller: _pageController,
            // 🔴 عدد لا نهائي من الصفحات
            itemCount: null,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              // 🔴 استخدم modulo للحصول على العرض الصحيح
              final actualIndex = index % widget.offers.length;
              final offer = widget.offers[actualIndex];

              return InkWell(
                onTap: () => Get.toNamed(
                  AppConstants.offerPackagesPage,
                  arguments: offer,
                ),
                child: OfferCardWidget(offer),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // 🔴 الـ indicator يعرض الصفحة الحقيقية
        AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            final page = _pageController.hasClients && _pageController.page != null
                ? _pageController.page! % widget.offers.length
                : 0;

            return SmoothPageIndicator(
              controller: PageController(initialPage: page.round()),
              count: widget.offers.length,
              effect: ExpandingDotsEffect(
                activeDotColor: CustomColors.mainColor,
                dotColor: Colors.grey.shade300,
                dotHeight: 8,
                dotWidth: 8,
                expansionFactor: 3,
              ),
              onDotClicked: (index) {
                // احسب أقرب page number للـ index المطلوب
                final targetPage = _currentPage + (index - (_currentPage % widget.offers.length));

                _pageController.animateToPage(
                  targetPage,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
