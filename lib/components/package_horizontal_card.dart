import 'package:diet_picnic_client/components/custom_cached_network_image.dart';
import 'package:diet_picnic_client/core/custom_colors.dart';
import 'package:diet_picnic_client/models/package_model.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PackageHorizontalCard extends StatelessWidget {
  final PackageModel package;
  final VoidCallback? onTap;
  const PackageHorizontalCard({Key? key, required this.package, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,color: Colors.white,
      shadowColor: CustomColors.mainColor.withOpacity(0.15),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(flex: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: package.baseImage.isNotEmpty
                      ? SizedBox(

                    child: AspectRatio(aspectRatio: 1,
                      child: CustomCachedNetworkImage(
                        imageUrl: package.baseImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                      : Container(
                    width: 18.w,
                    height: 18.w,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, size: 40, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      package.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: CustomColors.mainColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      package.about,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),

                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: CustomColors.selectedNavBarColor, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}