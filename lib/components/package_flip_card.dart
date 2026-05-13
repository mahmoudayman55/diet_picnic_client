import 'dart:math';
import 'package:flutter/material.dart';

import '../core/custom_colors.dart';
import 'subscription_dialog.dart';

// ─── Dashed separator ─────────────────────────────────────────────────────────
class _DashedDivider extends StatelessWidget {
  final Color color;
  const _DashedDivider({this.color = Colors.white38});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      const dashW = 5.0;
      const gap = 4.0;
      final count = (constraints.maxWidth / (dashW + gap)).floor();
      return Row(
        children: List.generate(
          count,
          (_) => Container(
            width: dashW,
            height: 1.5,
            margin: const EdgeInsets.only(right: gap),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      );
    });
  }
}

// ─── Circle notch ─────────────────────────────────────────────────────────────
class _Notch extends StatelessWidget {
  final Color color;
  const _Notch({this.color = Colors.white24});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

// ─── Dot-pattern painter ──────────────────────────────────────────────────────
class _DotPatternPainter extends CustomPainter {
  final Color color;
  const _DotPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    const spacing = 18.0;
    const radius = 1.5;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotPatternPainter oldDelegate) => false;
}

// ─── Main card ────────────────────────────────────────────────────────────────
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
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
    setState(() => _isFront = !_isFront);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double sw = size.width;
    final double sh = size.height;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final angle = _animation.value * pi;
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          alignment: Alignment.center,
          child: angle < pi / 2
              ? _buildFront(context, sw, sh)
              : _buildBack(context, angle, sw, sh),
        );
      },
    );
  }

  // ── Front face ──────────────────────────────────────────────────────────────
  Widget _buildFront(BuildContext context, double sw, double sh) {
    final Color accent = widget.gradient.first;
    final Color accentDark = widget.gradient.last;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: accentDark.withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // ── Dot pattern overlay ────────────────────────────────────────
            Positioned.fill(
              child: CustomPaint(
                painter: _DotPatternPainter(
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),

            // ── Decorative bubbles ─────────────────────────────────────────
            Positioned(
              top: -sw * 0.10,
              right: -sw * 0.10,
              child: Container(
                width: sw * 0.32,
                height: sw * 0.32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: sh * 0.04,
              right: -sw * 0.05,
              child: Container(
                width: sw * 0.15,
                height: sw * 0.15,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.07),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: sh * 0.08,
              left: -sw * 0.08,
              child: Container(
                width: sw * 0.27,
                height: sw * 0.27,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -sh * 0.025,
              right: sw * 0.10,
              child: Container(
                width: sw * 0.17,
                height: sw * 0.17,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // ── Content ────────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: sw * 0.04, vertical: sh * 0.014),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ── Title glass panel ──────────────────────────────────
                          _GlassPanel(
                            child: Column(
                              children: [
                                // Small label
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: sw * 0.03, vertical: sh * 0.004),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.18),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.3)),
                                  ),
                                  child: Text(
                                    "الباقة",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                          color: Colors.white,
                                          letterSpacing: 1.5,
                                        ),
                                  ),
                                ),
                                SizedBox(height: sh * 0.008),
                                Text(
                                  widget.title,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge!
                                      .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        height: 1.2,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(0.2),
                                            offset: const Offset(0, 2),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                ),
                              ],
                            ),
                          ),

                          // ── Separator 1 ────────────────────────────────────────
                          _SectionSeparator(color: Colors.white30),

                          // ── About glass panel ──────────────────────────────────
                          _GlassPanel(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.info_outline_rounded,
                                        color: Colors.white70, size: sw * 0.035),
                                    SizedBox(width: sw * 0.015),
                                    Text(
                                      "نبذة",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge!
                                          .copyWith(
                                            color: Colors.white,
                                            letterSpacing: 1.2,
                                          ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: sh * 0.008),
                                Text(
                                  widget.smallDesc,
                                  maxLines: 10,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                        color: Colors.white.withOpacity(0.92),
                                        height: 1.5,
                                      ),
                                ),
                              ],
                            ),
                          ),

                          // ── Separator 2 ────────────────────────────────────────
                          _SectionSeparator(color: Colors.white30),

                          // ── Target glass panel ─────────────────────────────────
                          _GlassPanel(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.people_alt_outlined,
                                        color: Colors.white, size: sw * 0.035),
                                    SizedBox(width: sw * 0.015),
                                    Text(
                                      "مناسبة لمين؟",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge!
                                          .copyWith(
                                            color: Colors.white,
                                            letterSpacing: 1.2,
                                          ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: sh * 0.008),
                                Text(
                                  widget.target,
                                  maxLines: 10,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                        color: Colors.white,
                                        height: 1.5,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: sh * 0.01),

                  // ── Flip button ────────────────────────────────────────
                  GestureDetector(
                    onTap: _flip,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: sh * 0.016),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.28),
                            Colors.white.withOpacity(0.10),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.4), width: 1.2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "التفاصيل الكاملة",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          SizedBox(width: sw * 0.02),
                          Icon(Icons.flip_camera_android_rounded,
                              color: Colors.white, size: sw * 0.05),
                        ],
                      ),
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

  // ── Back face ───────────────────────────────────────────────────────────────
  Widget _buildBack(BuildContext context, double angle, double sw, double sh) {
    return Transform(
      transform: Matrix4.identity()..rotateY(pi),
      alignment: Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
              color: widget.gradient.first.withOpacity(0.2), width: 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Stack(
            children: [
              // Light dot pattern on back
              Positioned.fill(
                child: CustomPaint(
                  painter: _DotPatternPainter(
                    color: widget.gradient.first.withOpacity(0.04),
                  ),
                ),
              ),
              // Small top bubble accent
              Positioned(
                top: -sw * 0.075,
                left: -sw * 0.075,
                child: Container(
                  width: sw * 0.25,
                  height: sw * 0.25,
                  decoration: BoxDecoration(
                    color: widget.gradient.first.withOpacity(0.06),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(sw * 0.055),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: sw * 0.05,
                          backgroundColor:
                              widget.gradient.first.withOpacity(0.12),
                          child: Icon(Icons.info_outline,
                              color: widget.gradient.first, size: sw * 0.05),
                        ),
                        SizedBox(width: sw * 0.03),
                        Text(
                          "تفاصيل الباقة",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                color: widget.gradient.first,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: sh * 0.018),
                    Divider(color: widget.gradient.first.withOpacity(0.2)),
                    SizedBox(height: sh * 0.012),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          widget.fullDesc,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                color: Colors.black87,
                                height: 1.7,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(height: sh * 0.018),

                    // ── Coupon-style tear-off line ─────────────────────
                    Row(
                      children: [
                        _Notch(color: widget.gradient.first.withOpacity(0.15)),
                        SizedBox(width: sw * 0.01),
                        Expanded(
                          child: _DashedDivider(
                              color: widget.gradient.first.withOpacity(0.3)),
                        ),
                        SizedBox(width: sw * 0.01),
                        _Notch(color: widget.gradient.first.withOpacity(0.15)),
                      ],
                    ),

                    SizedBox(height: sh * 0.018),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: _flip,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: sh * 0.015),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(sw * 0.035),
                                border: Border.all(
                                    color: widget.gradient.first.withOpacity(0.4)),
                              ),
                              child: Text(
                                "رجوع",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                      color: widget.gradient.first,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: sw * 0.03),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => SubscriptionDialog.show(
                                context, widget.title, widget.gradient.first),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: sh * 0.015),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    widget.gradient.first,
                                    widget.gradient.last,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(sw * 0.035),
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.gradient.first.withOpacity(0.35),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Text(
                                "اشتراك",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
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
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Glass panel helper ───────────────────────────────────────────────────────
class _GlassPanel extends StatelessWidget {
  final Widget child;
  const _GlassPanel({required this.child});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.035, vertical: size.height * 0.012),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(size.width * 0.045),
        border: Border.all(color: Colors.white.withOpacity(0.22)),
      ),
      child: child,
    );
  }
}

// ─── Section separator (notch + dash + notch) ─────────────────────────────────
class _SectionSeparator extends StatelessWidget {
  final Color color;
  const _SectionSeparator({required this.color});

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.of(context).size.width;
    final sh = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: sh * 0.008),
      child: Row(
        children: [
          _Notch(color: color),
          SizedBox(width: sw * 0.01),
          Expanded(child: _DashedDivider(color: color)),
          SizedBox(width: sw * 0.01),
          _Notch(color: color),
        ],
      ),
    );
  }
}
