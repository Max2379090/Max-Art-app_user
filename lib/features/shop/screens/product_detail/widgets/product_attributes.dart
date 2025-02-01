import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/chips/rounded_choice_chips.dart';
import '../../../../../common/widgets/texts/section_heading.dart';
import '../../../../../common/widgets/texts/t_product_price_text.dart';
import '../../../../../common/widgets/texts/t_product_title_text.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/product/variation_controller.dart';
import '../../../models/product_model.dart';

class TProductAttributes extends StatelessWidget {
  const TProductAttributes({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = VariationController.instance;

    return Obx(
          () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// -- Selected Attribute Pricing & Description
          if (controller.selectedVariation.value.id.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TSectionHeading(title: 'Variation: '.tr, showActionButton: false),
                    const SizedBox(width: TSizes.spaceBtwItems),

                    /// Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            TProductTitleText(title: 'Price : '.tr, smallSize: true),
                            if (controller.selectedVariation.value.salePrice > 0)
                              Row(
                                children: [
                                  const SizedBox(width: TSizes.spaceBtwItems),
                                  Text(
                                    '${controller.selectedVariation.value.price.toStringAsFixed(0)} FCFA', // Corrected to use toStringAsFixed(0)
                                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                                      color: Colors.red,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                  const SizedBox(width: TSizes.spaceBtwItems),
                                ],
                              ),
                            TProductPriceText(
                              price: controller.selectedVariation.value.salePrice > 0
                                  ? controller.selectedVariation.value.salePrice.toStringAsFixed(0)
                                  : controller.selectedVariation.value.price.toStringAsFixed(0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            TProductTitleText(title: 'Stock : '.tr, smallSize: true),
                            Text(
                              controller.selectedVariation.value.stock.toString(),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                TProductTitleText(
                  title: controller.selectedVariation.value.description ?? '',
                  smallSize: true,
                  maxLines: 4,
                ),
              ],
            ),
          const SizedBox(height: TSizes.spaceBtwItems),

          /// -- Attributes
          if (product.productAttributes != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: product.productAttributes!.map(
                    (attribute) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TSectionHeading(title: attribute.name ?? '', showActionButton: false),
                      const SizedBox(height: TSizes.spaceBtwItems / 2),
                      Obx(
                            () => Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: attribute.values?.map((attributeValue) {
                            final isSelected =
                                controller.selectedAttributes[attribute.name] == attributeValue;
                            final available = controller
                                .getAttributesAvailabilityInVariation(
                              product.productVariations!,
                              attribute.name!,
                            )
                                .contains(attributeValue);

                            return TChoiceChip(
                              text: attributeValue,
                              selected: isSelected,
                              onSelected: available
                                  ? (selected) {
                                if (selected) {
                                  controller.onAttributeSelected(
                                    product,
                                    attribute.name ?? '',
                                    attributeValue,
                                  );
                                }
                              }
                                  : null,
                            );
                          }).toList() ??
                              [],
                        ),
                      ),
                      const SizedBox(height: TSizes.spaceBtwItems),
                    ],
                  );
                },
              ).toList(),
            ),
        ],
      ),
    );
  }
}
