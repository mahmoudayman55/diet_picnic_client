import 'package:flutter/material.dart';
import '../custom_colors.dart';

class AppGradients {
  static List<Color> getGradient(int index) {
    if (index < 0 || index >= CustomColors.packageGradients.length) {
      return CustomColors.packageGradients[0];
    }
    return CustomColors.packageGradients[index];
  }
}
