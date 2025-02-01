import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../shimmers/shimmer.dart';

class TCircularImage extends StatelessWidget {
  const TCircularImage({
    super.key,
    this.width = 55,
    this.height = 55,
    this.overlayColor,
    this.backgroundColor,
    required this.image,
    this.fit = BoxFit.cover,
    this.padding = TSizes.sm,
    this.isNetworkImage = false,
  });

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ?? (THelperFunctions.isDarkMode(context) ? TColors.black : TColors.white),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: isNetworkImage
            ? CachedNetworkImage(
          fit: fit,
          color: overlayColor,
          imageUrl: image,
          width: width - padding * 2, // Ajuste la largeur disponible
          height: height - padding * 2, // Ajuste la hauteur disponible
          progressIndicatorBuilder: (context, url, downloadProgress) =>
          const TShimmerEffect(width: 55, height: 55),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        )
            : Image.asset(
          image,
          fit: fit,
          color: overlayColor,
          width: width - padding * 2,
          height: height - padding * 2,
        ),
      ),
    );
  }
}
