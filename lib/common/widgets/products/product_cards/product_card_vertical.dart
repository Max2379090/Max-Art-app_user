import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../features/personalization/controllers/ratiing_controller.dart';
import '../../../../features/shop/controllers/product/product_controller.dart';
import '../../../../features/shop/models/product_model.dart';
import '../../../../features/shop/screens/product_detail/product_detail.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../styles/shadows.dart';
import '../../custom_shapes/containers/rounded_container.dart';
import '../../images/t_rounded_image.dart';
import '../../texts/t_brand_title_text_with_verified_icon.dart';
import '../../texts/t_product_title_text.dart';
import '../favourite_icon/favourite_icon.dart';
import 'widgets/add_to_cart_button.dart';
import 'widgets/product_card_pricing_widget.dart';
import 'widgets/product_sale_tag.dart';


class TProductCardVertical extends StatelessWidget {
  const TProductCardVertical({super.key, required this.product, this.isNetworkImage = true,});

  final ProductModel product;
  final bool isNetworkImage;

  @override
  Widget build(BuildContext context) {
    final productController = ProductController.instance;
    final salePercentage = productController.calculateSalePercentage(product.price, product.salePrice);
    final dark = THelperFunctions.isDarkMode(context);
    final RatingController controller = Get.put(RatingController());

    // Fetch ratings for the product when the widget is built (only once)
    if (controller.ratings.isEmpty) {
      controller.fetchRatings(product.id);
    }

    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailScreen(product: product)),

      child: Container(
        width: 180,
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [TShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          color: dark ? TColors.darkerGrey : TColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TRoundedContainer(
              height: 180,
              width: 180,
              padding: const EdgeInsets.all(TSizes.sm),
              backgroundColor: dark ? TColors.dark : TColors.light,
              child: Stack(
                children: [
                  Center(child: TRoundedImage(imageUrl: product.thumbnail, applyImageRadius: true, isNetworkImage: isNetworkImage)),
                  if (salePercentage != null) ProductSaleTagWidget(salePercentage: salePercentage),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: TFavouriteIcon(productId: product.id),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2),

            Padding(
              padding: const EdgeInsets.only(left: TSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TProductTitleText(title: product.title, smallSize: true),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),
                  TBrandTitleWithVerifiedIcon(title: product.brand!.name, brandTextSize: TextSizes.small),
                  const SizedBox(height: TSizes.spaceBtwItems / 2),

                  // Section des évaluations
                //  Obx(() {
                   // double overallRating = controller.ratings.isNotEmpty
                    //    ? controller.ratings.fold(0.0, (sum, item) => sum + item.rating) / controller.ratings.length
                     //   : 0.0;

                    //return Column(
                    //  crossAxisAlignment: CrossAxisAlignment.start,
                    //  children: [
                    //    const SizedBox(height: 4),
                    //    Row(
                     //     mainAxisAlignment: MainAxisAlignment.start,
                      //    children: List.generate(5, (index) {
                        //    return Icon(
                        //      Iconsax.star1,
                         //     color: index < overallRating ? Colors.amber : Colors.grey[300],
                        //      size: 16,
                        //    );
                        //  }),
                      //  ),

                   // ],
                   // );
                 // }),

                ],
              ),
            ),

            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PricingWidget(product: product),
                ProductCardAddToCartButton(product: product),
              ],
            ),
          ],
        ),
      ),
    );
  }
}