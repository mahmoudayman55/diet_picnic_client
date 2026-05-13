import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/custom_colors.dart';
import 'subscription_dialog.dart';

class PackageFlipCard extends StatefulWidget {
  final String title;
  final String target;
  final String smallDesc;
  final String fullDesc;
  final List<Color> gradient;
  final VoidCallback onAction;

  const PackageFlipCard({
    super.key,
    required this.title,
    required this.target,
    required this.smallDesc,
    required this.fullDesc,
    required this.gradient,
    required this.onAction,
  });

  @override
  State<PackageFlipCard> createState() => _PackageFlipCardState();
}

class _PackageFlipCardState extends State<PackageFlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flip() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    setState(() {
      _isFront = !_isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final angle = _animation.value * pi;
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateY(angle),
          alignment: Alignment.center,
          child: angle < pi / 2 ? _buildFront() : _buildBack(angle),
        );
      },
    );
  }

  Widget _buildFront() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: widget.gradient.last.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Align(
            alignment: Alignment.center,
            child: Text(
              widget.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Colors.white,
                    height: 1.2,
                  ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.smallDesc,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            "مناسبة لمين؟",
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(color: Colors.white),
          ),
          Text(
            widget.target,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  color: Colors.white,
                  height: 1.4,
                ),
            maxLines: 8,
            overflow: TextOverflow.ellipsis,
          ),

          InkWell(
            onTap: _flip,
            borderRadius: BorderRadius.circular(15),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.3),
                    Colors.white.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "التفاصيل",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.flip_camera_android_rounded,
                      color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBack(double angle) {
    return Transform(
      transform: Matrix4.identity()..rotateY(pi),
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
              color: widget.gradient.first.withOpacity(0.2), width: 2),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: widget.gradient.first.withOpacity(0.1),
                  child: Icon(Icons.info_outline, color: widget.gradient.first),
                ),
                const SizedBox(width: 12),
                Text(
                  "تفاصيل الباقة",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        color: widget.gradient.first,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  widget.fullDesc,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        color: Colors.black87,
                        height: 1.6,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _flip,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: widget.gradient.first.withOpacity(0.5)),
                      ),
                      child: Text(
                        "رجوع",
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                              color: widget.gradient.first,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => SubscriptionDialog.show(
                        context, widget.title, widget.gradient.first),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.gradient.first,
                            widget.gradient.last,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: widget.gradient.first.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        "اشتراك",
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
