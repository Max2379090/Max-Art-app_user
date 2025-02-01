import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/product/order_controller.dart';
import '../../models/order_model.dart';

class OrderDetailPage extends StatelessWidget {
  final OrderModel order;
  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderController());

    // A function to get the color based on the order status
    Color getStatusColor(String status) {
      switch (status.toLowerCase()) {
        case 'shipped':
          return Colors.blue;
        case 'pending':
          return Colors.orange;
        case 'delivered':
          return Colors.green;
        case 'cancelled':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Order'.tr),
        backgroundColor: TColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.spaceBtwItems),
        child: ListView(
          children: [
            /// Status Row
            Row(
              children: [
                const Icon(Iconsax.ship),
                const SizedBox(width: TSizes.spaceBtwItems / 2),
                Text(
                  order.orderStatusText.tr,
                  style: TextStyle(
                    color: getStatusColor(order.orderStatusText),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            /// Order Details
            _buildOrderDetailRow(
              context,
              label: 'Order ID'.tr,
              value: order.id,
              icon: Iconsax.tag,
            ),
            _buildOrderDetailRow(
              context,
              label: 'Shipping Date'.tr,
              value: order.formattedDeliveryDate,
              icon: Iconsax.calendar,
            ),
            _buildOrderDetailRow(
              context,
              label: 'Payment Method'.tr,
              value: order.paymentMethod,
              icon: Iconsax.wallet_1,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            /// Delivery Address
            _buildOrderDetailRow(
              context,
              label: 'Delivery Address'.tr,
              value: order.formattedOrderDate ?? 'Not provided',
              icon: Iconsax.location,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),




          ],
        ),
      ),
    );
  }

  /// Helper method to build order detail rows
  Widget _buildOrderDetailRow(BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    Color? statusColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: statusColor ?? TColors.primary),
        const SizedBox(width: TSizes.spaceBtwItems / 2),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.apply(
                  color: statusColor ?? TColors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
