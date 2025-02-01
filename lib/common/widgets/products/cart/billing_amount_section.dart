import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../features/shop/controllers/product/checkout_controller.dart';
import '../../../../utils/constants/sizes.dart';

class TBillingAmountSection extends StatelessWidget {
  const TBillingAmountSection({super.key, required this.subTotal});

  final double subTotal;

  @override
  Widget build(BuildContext context) {
    final controller = CheckoutController.instance;
    return Column(
      children: [
        /// -- Sub Total
        Row(
          children: [
            Expanded(child: Text('Subtotal'.tr, style: Theme.of(context).textTheme.bodyMedium)),
            Text('${subTotal.toStringAsFixed(0)} FCFA', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),

        /// -- Shipping Fee
        Row(
          children: [
            Expanded(child: Text('Shipping Fee'.tr, style: Theme.of(context).textTheme.bodyMedium)),
            Obx(
                  () => Text(
                '${controller.isShippingFree(subTotal) ? 'Free'.tr : (controller.getShippingCost(subTotal)).toStringAsFixed(0)} FCFA',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems / 2),

        /// -- Tax Fee
        Row(
          children: [
            Expanded(child: Text('Tax Fee'.tr, style: Theme.of(context).textTheme.bodyMedium)),
            Obx(
                  () => Text(
                '${controller.getTaxAmount(subTotal).toStringAsFixed(0)} FCFA',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems),

        /// -- Order Total
        Row(
          children: [
            Expanded(child: Text('Order Total'.tr, style: Theme.of(context).textTheme.titleMedium)),
            Text(
              '${controller.getTotal(subTotal).toStringAsFixed(0)} FCFA',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ],
    );
  }
}
