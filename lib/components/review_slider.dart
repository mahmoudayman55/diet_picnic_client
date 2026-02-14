import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'review_widget.dart'; // adjust import

class AutoSlidingReviewsList extends StatefulWidget {
  final List reviews;
  const AutoSlidingReviewsList({Key? key, required this.reviews})
      : super(key: key);

  @override
  State<AutoSlidingReviewsList> createState() => _AutoSlidingReviewsListState();
}

class _AutoSlidingReviewsListState extends State<AutoSlidingReviewsList> {
  late final PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);

    // Auto slide every 4 seconds
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (widget.reviews.isEmpty || !_pageController.hasClients) return;

      _currentPage++;
      if (_currentPage >= widget.reviews.length) {
        _currentPage = 0;
      }

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
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.reviews.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6.0),
          child: ReviewWidget(
            review: widget.reviews[index],
            maxLines: 3,
          ),
        );
      },
    );
  }
}
