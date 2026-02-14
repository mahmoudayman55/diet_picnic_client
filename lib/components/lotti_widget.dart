import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieWidget extends StatelessWidget {
  String img;

  LottieWidget(this.img);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: img.endsWith("json")
          ? Lottie.asset(img,backgroundLoading: false,
              frameRate: FrameRate.max,
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * .4)
          : Image.asset(img,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.contain,
              height: MediaQuery.of(context).size.height * .4),
    );
  }
}
