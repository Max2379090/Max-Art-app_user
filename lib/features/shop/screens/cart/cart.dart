import 'package:Max_store/features/shop/screens/store/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/product/cart_controller.dart';
import '../checkout/checkout.dart';
import 'widgets/cart_items.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CartController.instance;
    final cartItems = controller.cartItems;
    return Scaffold(
      /// -- AppBar
      appBar:

      AppBar(
        backgroundColor: TColors.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Cart".tr,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: Obx(() {
        /// Nothing Found Widget
        final emptyWidget = TAnimationLoaderWidget(
          text: 'Whoops! Cart is EMPTY.'.tr,
          animation: TImages.cartAnimation,
          showAction: true,
          actionText: 'Let\'s fill it'.tr,
          onActionPressed: () => Get.off(() => const StoreScreen()),
        );

        /// Cart Items
        return cartItems.isEmpty
            ? emptyWidget
            : const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(TSizes.defaultSpace),

            /// -- Items in Cart
            child: TCartItems(),
          ),
        );
      }),

      /// -- Checkout Button
      bottomNavigationBar: Obx(
            () {
          return cartItems.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.to(() => const CheckoutScreen()),
                child: Obx(() =>
                    RichText(
                      text: TextSpan(
                        text: 'Buy now'.tr,
                        style: const TextStyle(fontWeight: FontWeight. w600,fontSize:18.5,),
                        children:  <TextSpan>[
                          TextSpan(text: ' ${controller.totalCartPrice.value.toStringAsFixed(0)} FCFA'),
                        ],
                      ),
                    )
                ),
              ),
            ),
          )
              : const SizedBox();
        },
      ),
    );
  }
}
