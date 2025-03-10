import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../features/shop/controllers/product/cart_controller.dart';
import '../../../../features/shop/models/product_model.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import 'add_remove_cart_button.dart';

class TBottomAddToCart extends StatelessWidget {
  const TBottomAddToCart({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;
    controller.updateAlreadyAddedProductCount(product);
    final dark = THelperFunctions.isDarkMode(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace, vertical: TSizes.defaultSpace / 2),
      decoration: BoxDecoration(
        color: dark ? TColors.darkerGrey : TColors.light,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(TSizes.cardRadiusLg),
          topRight: Radius.circular(TSizes.cardRadiusLg),
        ),
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Add OR Remove Cart Product Icon Buttons
            TProductQuantityWithAddRemoveButton(
              quantity: controller.productQuantityInCart.value,
              add: () => controller.productQuantityInCart.value += 1,
              // Disable remove when cart count is less than 1
              remove: () => controller.productQuantityInCart.value < 1 ? null : controller.productQuantityInCart.value -= 1,
            ),
            //
            // Add to cart button wrapped in Expanded
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: controller.productQuantityInCart.value < 1 ? null : () => controller.addToCart(product),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: TSizes.md), // Ensure vertical padding is reasonable
                  backgroundColor: TColors.black,
                  side: const BorderSide(color: TColors.black),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // Centers content horizontally
                  children: [
                    const Icon(Iconsax.shopping_bag, size: 20), // Reduce icon size if needed
                    const SizedBox(width: TSizes.spaceBtwItems / 2),
                    Flexible(
                      child: Text(
                        'Add to Bag'.tr,
                        overflow: TextOverflow.ellipsis, // Prevents text from overflowing
                        style: const TextStyle(fontSize: 14), // Adjust font size if necessary
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        )
      ),
    );
  }
}
