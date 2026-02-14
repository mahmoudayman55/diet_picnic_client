
import 'package:diet_picnic_client/components/lotti_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class IntroScreen extends StatelessWidget {
  final String label;
  final double height;
  final double width;
  final String details;
  final String img;

  IntroScreen(
      {required this.label,
      required this.details,
      required this.height,
      required this.width,
      required this.img});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        padding: EdgeInsets.all(width * 0.02),
        height: 0.8 * height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
             LottieWidget(img),
            Expanded(
              child: Column(
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            details,
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(fontWeight: FontWeight.w300,color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
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
