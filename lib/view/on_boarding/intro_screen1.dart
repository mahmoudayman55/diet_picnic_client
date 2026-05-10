import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IntroScreen extends StatelessWidget {
  final String label;
  final double height;
  final double width;
  final String details;
  final String img;
  final double animationValue;

  IntroScreen({
    required this.label,
    required this.details,
    required this.height,
    required this.width,
    required this.img,
    this.animationValue = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitUp,
    ]);

    // A very visible animation mix!
    final double scale = (1 - (animationValue.abs() * 0.4)).clamp(0.0, 1.0);
    // Opacity fades out faster so the overlap is clean
    final double opacity = (1 - animationValue.abs() * 1.5).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Opacity(
        opacity: opacity,
        child: Container(
          padding: EdgeInsets.all(width * 0.05),
          height: height * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 3,
                child: Transform(
                  alignment: Alignment.center,
                  // 3D Flip + Slide
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.002) // Perspective for 3D
                    ..rotateY(-animationValue * pi / 1.2)
                    ..scale(scale)
                    ..translate(animationValue * width),
                  child: Image.asset(
                    img,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                flex: 2,
                child: Transform(
                  alignment: Alignment.center,
                  // Text slides extremely fast from the opposite direction
                  transform: Matrix4.identity()
                    ..translate(-animationValue * width),
                  child: Column(
                    children: [
                      Text(
                        label,
                        style: Theme.of(context).textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              details,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                      fontWeight: FontWeight.w400, height: 1.5),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
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
