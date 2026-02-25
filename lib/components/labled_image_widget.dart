import 'package:diet_picnic_client/components/custom_cached_network_image.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:flutter/material.dart';

Widget buildLabeledImage(
    String label, String url, double width, double height) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 16),
    child: SizedBox(
      height: height * 0.25,
      width: width,
      child: AspectRatio(
        aspectRatio: 19 / 6,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CustomCachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.cover,
          ),
        ),
      ),
    ),
  );
}
