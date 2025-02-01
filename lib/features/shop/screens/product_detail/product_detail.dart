import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';

import '../../../../common/widgets/products/cart/bottom_add_to_cart_widget.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../personalization/controllers/ratiing_controller.dart';
import '../../controllers/product/cart_controller.dart';
import '../../models/product_model.dart';
import '../cart/cart.dart';
import '../product_reviews/widgets/add_reviewer.dart';
import 'widgets/product_attributes.dart';
import 'widgets/product_detail_image_slider.dart';
import 'widgets/product_meta_data.dart';
import 'widgets/rating_share_widget.dart';

class ProductDetailScreen extends StatelessWidget {
   ProductDetailScreen({super.key, required this.product});

  final ProductModel product;
  final cartController = CartController.instance;


  @override
  Widget build(BuildContext context) {
    final RatingController controller = Get.put(RatingController());

    // Fetch ratings for this specific product
    controller.fetchRatings(product.id);

    final subTotal = cartController.totalCartPrice; // Ensure this is reactive

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 1 - Product Image Slider
            TProductImageSlider(product: product),

            /// 2 - Product Details
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TSizes.defaultSpace,
                vertical: TSizes.defaultSpace,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// - Rating & Share
                  TRatingAndShare(productId: product.id),

                  /// - Price, Title, Stock, & Brand
                  TProductMetaData(productId: product.id, product: product),
                  const SizedBox(height: TSizes.spaceBtwSections / 2),

                  /// - Attributes (if available)
                  if (product.productVariations?.isNotEmpty ?? false)
                    TProductAttributes(product: product),
                  if (product.productVariations?.isNotEmpty ?? false)
                    const SizedBox(height: TSizes.spaceBtwSections),

             SizedBox(
                       width: TDeviceUtils.getScreenWidth(context),
                        child: Obx(() {
                              final subTotal = cartController.totalCartPrice.value;
                     return ElevatedButton(
                         child: Text('Buy now'.tr),
                       onPressed: () {
                        if (subTotal <= 0) {
                     TLoaders.warningSnackBar(
                    title: 'Empty Cart'.tr,
                     message:'Add items in the cart in order to proceed.'.tr,
                    );
                  } else {
                      Get.to(() => const CartScreen());
                 }
             },
                    );
            }),
            ),


    const SizedBox(height: TSizes.spaceBtwSections),

                  /// - Description
                  TSectionHeading(title: 'Description'.tr, showActionButton: false),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  ReadMoreText(
                    product.description ?? 'No description available',
                    trimLines: 2,
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' Show more'.tr,
                    trimExpandedText: ' Less'.tr,
                    moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    lessStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  /// - Reviews Section
                  const Divider(),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => TSectionHeading(
                        title: '${'Reviews'.tr} (${controller.ratingCount.value})',
                        showActionButton: false,
                      )),
                      IconButton(
                        icon: const Icon(Iconsax.arrow_right_3, size: 18),
                        onPressed: () => Get.to(() => RatingPage(productId: product.id)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: TBottomAddToCart(product: product),
    );
  }
}
