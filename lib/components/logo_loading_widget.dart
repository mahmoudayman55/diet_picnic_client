import 'dart:math' as math;
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:flutter/material.dart';

class LogoLoadingWidget extends StatefulWidget {
  final bool showIndicator;
  final double size;

  const LogoLoadingWidget({
    Key? key,
    this.showIndicator = true, // 👈 Default true
    this.size = 60, // 👈 Default true
  }) : super(key: key);

  @override
  State<LogoLoadingWidget> createState() => _LogoLoadingWidgetState();
}

class _LogoLoadingWidgetState extends State<LogoLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ✅ Circular Gradient Loading Indicator (optional)
          if (widget.showIndicator)
            SizedBox(
              width: widget.size + 30,
              height:widget. size + 30,
              child: ShaderMask(
                shaderCallback: (bounds) => SweepGradient(
                  startAngle: 0.0,
                  endAngle: math.pi * 2,
                  colors: [
                    Colors.white,
                    CustomColors.mainColor,
                    Colors.white,
                    CustomColors.mintGreen,
                    Colors.white,
                  ],
                  stops: const [0.1, 0.3, 0.5, 0.8, 1.0],
                  transform: GradientRotation(-math.pi / 2),
                ).createShader(bounds),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            ),

          // ✅ Pulsing Logo
          ScaleTransition(
            scale: _scaleAnimation,
            child: Image.asset(
              "assets/images/logo.png",
              width:widget.size ,
              height: widget.size,
            ),
          ),
        ],
      ),
    );
  }
}
