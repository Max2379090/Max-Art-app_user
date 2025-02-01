import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_text_field/country_code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../common/widgets/products/cart/billing_amount_section.dart';
import '../../../../common/widgets/products/cart/coupon_code.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../personalization/controllers/address_controller.dart';
import '../../controllers/product/cart_controller.dart';
import '../../controllers/product/checkout_controller.dart';
import '../../controllers/product/order_controller.dart';
import '../../models/data_model.dart';
import '../../models/payment_method_model.dart';
import '../cart/widgets/cart_items.dart';
import 'widgets/billing_address_section.dart';


class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {

  final checkoutController = CheckoutController.instance;
  final cartController = CartController.instance;
  final addressController = AddressController.instance;
  final orderController = Get.put(OrderController());
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Rx<PaymentMethodModel> selectedPaymentMethod = PaymentMethodModel.empty().obs;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  late final DataModel _dataModel;



  @override
  Widget build(BuildContext context) {
    final controller = CheckoutController.instance;
    final dark = THelperFunctions.isDarkMode(context);
    final subTotal = cartController.totalCartPrice.value;

    return Scaffold(
      appBar: TAppBar(
          title: Text('Order Review'.tr), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// -- Items in Cart
              const TCartItems(showAddRemoveButtons: false),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// -- Coupon TextField
              const TCouponCode(),
              const SizedBox(height: TSizes.spaceBtwSections),

              /// -- Billing Section
              TRoundedContainer(
                showBorder: true,
                padding: const EdgeInsets.all(TSizes.md),
                backgroundColor: dark ? TColors.black : TColors
                    .white,
                child: Column(
                  children: [

                    /// Pricing
                    TBillingAmountSection(subTotal: subTotal),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    /// Divider
                    const Divider(),
                    const SizedBox(
                        height: TSizes.spaceBtwItems),

                    /// Payment Methods

                    TSectionHeading(
                      title: 'Payment Method'.tr,
                      buttonTitle: 'Change'.tr,
                      showActionButton: false,
                      onPressed: () {
                        controller.selectPaymentMethod(context);
                      },
                    ),
                    const SizedBox(
                        height: TSizes.spaceBtwItems / 2),

                    Obx(
                          () =>
                          Row(
                            children: [
                              TRoundedContainer(
                                width: 60,
                                height: 35,
                                backgroundColor: THelperFunctions
                                    .isDarkMode(
                                    context)
                                    ? TColors.light
                                    : TColors.white,
                                padding: const EdgeInsets
                                    .all(TSizes.sm),
                                child: Image(
                                    image: AssetImage(
                                        controller.selectedPaymentMethod.value.image), fit: BoxFit.contain),),
                              const SizedBox(
                                  width: TSizes
                                      .spaceBtwItems /
                                      2),
                              Text(controller.selectedPaymentMethod.value.name.toString(), style: Theme.of(context).textTheme.bodyLarge),
                            ],
                          ),
                    ),

                    const SizedBox(
                        height: TSizes.spaceBtwItems / 2),
                    Container(
                      height: 65,
                      // can customize height
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius
                            .circular(10),
                        color: Colors.grey[100],),
                      child:
                      CountryCodeTextField(
                        keyboardType: TextInputType.number,

                        controller:numberController,

                        decoration: InputDecoration(

                          suffixIcon: IconButton(
                              onPressed: () {controller.selectPaymentMethod(context);},
                              icon: const Icon(Iconsax
                                  .arrow_down_1,
                                  color: Colors.black)
                          ),
                          labelText: 'Phone Number'.tr,
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        initialCountryCode: 'CM',
                      ),
                    ),


                    const SizedBox(
                        height: TSizes.spaceBtwSections),

                    /// Address
                    const TAddressSection(
                        isBillingAddress: false),
                    const SizedBox(
                        height: TSizes.spaceBtwItems),

                    /// Divider
                    const Divider(),
                    const SizedBox(
                        height: TSizes.spaceBtwItems),

                    /// Address Checkbox
                    Obx(
                          () =>
                          CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text('Billing Address is Same as Shipping Address'.tr),
                            value: addressController
                                .billingSameAsShipping
                                .value,
                            onChanged: (value) =>
                            addressController
                                .billingSameAsShipping
                                .value = value ?? true,
                          ),
                    ),
                    const SizedBox(
                        height: TSizes.spaceBtwItems),

                    /// Divider
                    Obx(() =>
                    !addressController.billingSameAsShipping
                        .value
                        ? const Divider()
                        : const SizedBox.shrink()),

                    /// Shipping Address
                    Obx(() =>
                    !addressController.billingSameAsShipping
                        .value
                        ? const TAddressSection(
                        isBillingAddress: true)
                        : const SizedBox.shrink()),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),


      /// -- Checkout Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (subTotal <= 0) {
                TLoaders.warningSnackBar(
                  title: 'Empty Cart'.tr,
                  message: 'Add items in the cart in order to proceed.'.tr,
                );
              } else if (numberController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  TLoaders.warningSnackBar(
                    title: 'Empty field'.tr,
                    message: 'Add a payment number in order to proceed.'.tr,
                  ),
                );
              } else {
                print("");
                // Call createData before processing the order
                orderController.processOrder(subTotal);
                orderController.createData(
                  subTotal.toStringAsFixed(0),
                  "237${numberController.text}",
                  controller.selectedPaymentMethod.value.name.toString(),
                  'description'.tr,
                  // pass controller here
                  context,
                );
              }
            },
            child: RichText(
              text: TextSpan(
                text: 'Confirm'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.5,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: ' ${checkoutController.getTotal(subTotal).toStringAsFixed(0)} FCFA',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }



}

