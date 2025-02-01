import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../personalization/controllers/ratiing_controller.dart';

class TRatingAndShare extends StatelessWidget {

  const TRatingAndShare({super.key, required this.productId});
  final String productId; // Accept product ID as a parameter
  @override
  Widget build(BuildContext context) {
    final RatingController controller = Get.put(RatingController());

    // Fetch ratings for the specific product when widget is built
    controller.fetchRatings(productId);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// Rating
        Row(
          children: [
            const Icon(Iconsax.star5, color: Colors.amber, size: 24),
            const SizedBox(width: TSizes.spaceBtwItems / 2),
            Obx(() => Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${controller.averageRating.value.toStringAsFixed(1)} ',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  TextSpan(
                    text: '(${controller.ratingCount.value})',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )),
          ],
        ),

        /// Share Button
        IconButton(
          onPressed: () {
            Share.share('Check out this product at https://www.example.com/product/$productId');
          },
          icon: const Icon(Icons.share, size: TSizes.iconMd),
        ),
      ],
    );
  }
}
