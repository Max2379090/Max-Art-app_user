import 'package:flutter/material.dart';

import '../../../../../features/shop/controllers/product/product_controller.dart';
import '../../../../../features/shop/models/product_model.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../texts/t_product_price_text.dart';

class PricingWidget extends StatelessWidget {
  const PricingWidget({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Actual Price if sale price is not null
          if (product.productType == ProductType.single.toString() && product.salePrice > 0)
            Padding(
              padding: const EdgeInsets.only(left: TSizes.sm),
              child: Text(
                '${product.price.toStringAsFixed(0)} FCFA', // Append the currency symbol to the price
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Colors.red, // Set the color to red
                  decoration: TextDecoration.lineThrough, // Apply line-through decoration
                ),
              ),
            ),

          /// Price, Show sale price as main price if sale exists
          Padding(
            padding: const EdgeInsets.only(left: TSizes.sm),
            child: TProductPriceText(
              price: ProductController.instance.getProductPrice(product),
            ),
          ),
        ],
      ),
    );
  }
}
