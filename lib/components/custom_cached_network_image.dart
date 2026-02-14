import 'package:cached_network_image/cached_network_image.dart';
import 'package:diet_picnic_client/components/loading_widget.dart';
import 'package:diet_picnic_client/components/logo_loading_widget.dart';
import 'package:flutter/material.dart';


class CustomCachedNetworkImage extends StatelessWidget {
  final String imageUrl;

  final BoxFit fit;
  bool infinitySize;
  CustomCachedNetworkImage(
      {required this.imageUrl,
      this.fit = BoxFit.cover,
      this.infinitySize = false});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      alignment: Alignment.center,
      imageUrl: imageUrl,
      width: infinitySize ? double.infinity : null,
      height: infinitySize ? double.infinity : null,
      fit: fit,
      placeholder: (context, url) => Container(
        alignment: Alignment.center,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [

                LogoLoadingWidget(),
              ],
            ),
          ),
        ),
      ),
      errorWidget: (context, url, error) =>  Image.asset("assets/images/logob.png"),
    );
  }
}
