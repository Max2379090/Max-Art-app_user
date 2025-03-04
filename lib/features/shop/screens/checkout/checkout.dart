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
  final RxDouble walletBalance = 0.0.obs;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  @override
  void initState() {
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    final controller = CheckoutController.instance;
    final dark = THelperFunctions.isDarkMode(context);
    final subTotal = cartController.totalCartPrice.value;

    return Scaffold(
      appBar: TAppBar(title: Text('Order Review'.tr), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              const TCartItems(showAddRemoveButtons: false),
              const SizedBox(height: TSizes.spaceBtwSections),
              const TCouponCode(),
              const SizedBox(height: TSizes.spaceBtwSections),
              TRoundedContainer(
                showBorder: true,
                padding: const EdgeInsets.all(TSizes.md),
                backgroundColor: dark ? TColors.black : TColors.white,
                child: Column(
                  children: [
                    TBillingAmountSection(subTotal: subTotal),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    const Divider(),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TSectionHeading(
                      title: 'Payment Method'.tr,
                      buttonTitle: 'Change'.tr,
                      showActionButton: false,
                    ),
                    const SizedBox(height: 20),

                    // Payment Method Selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildPaymentMethodButton(
                            PaymentMethodModel(name: 'Wallet Max Store', image: 'assets/icons/payment_methods/Wallet.jpg', )),
                        _buildPaymentMethodButton(
                            PaymentMethodModel(name: 'Mobile Money', image: 'assets/icons/payment_methods/orang_whiet_mtn.png')),
                        _buildPaymentMethodButton(
                            PaymentMethodModel(name: 'Bank Card', image: 'assets/icons/payment_methods/master-card.png')),
                        _buildPaymentMethodButton(
                            PaymentMethodModel(name: 'PayPal', image: 'assets/icons/payment_methods/paypal.png', )),
                      ],
                    ),

                    const SizedBox(height: 25),

                    // Show Wallet Balance for "Wallet Max Store"
                    Obx(() {
                      if (selectedPaymentMethod.value.name == 'Wallet Max Store') {
                        return StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance.collection('Users').doc('Mk2sY0Tbw5Uo3PHEyPU4AMfEMHt2').snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator(color: Colors.white);
                            }

                            if (!snapshot.hasData || !snapshot.data!.exists) {
                              return Text(
                                "0 F CFA",
                                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: Colors.white),
                              );
                            }

                            var data = snapshot.data!;
                            double balance = (data['balance'] is String)
                                ? double.tryParse(data['balance']) ?? 0.0
                                : (data['balance'] as num).toDouble();

                            walletBalance.value = balance; // Updating the value

                            return Obx(() {
                              return Text(
                                "Wallet Balance: ${walletBalance.value.toStringAsFixed(0)} F CFA",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color:dark ? TColors.light: TColors.primary,),
                              );
                            });
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    // Show Phone Number Input for "Mobile Money"
                    Obx(() {
                      if (selectedPaymentMethod.value.name == 'Mobile Money') {
                        return  Column(
                          children: [
                            CountryCodeTextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Phone Number'.tr,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(),
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                        ),
                                        builder: (context) {
                                          return FractionallySizedBox(
                                            heightFactor: 0.6, // Set the height factor to 0.6
                                            child: Padding(
                                              padding: EdgeInsets.all(20.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min, // Ensures the sheet takes only necessary space
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Choose",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      const Text(
                                                        "a number",
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold,
                                                          color: TColors.primary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 20),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        height: 50,
                                                        width: 335,
                                                        padding: EdgeInsets.all(8),
                                                        decoration: BoxDecoration(
                                                          color: Colors.grey[350],
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text('+237 690573912', style: TextStyle(fontSize: 16, color:dark ? TColors.black : TColors.primary,)),
                                                            Icon(Icons.check_circle, color: Colors.green),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Icon(Icons.cancel, color: Colors.grey[350]),
                                                    ],
                                                  ),
                                                  SizedBox(height: 25),
                                                  ElevatedButton.icon(
                                                    onPressed: () {
                                                      // Handle "Add" button action
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      minimumSize: Size(double.infinity, 50),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                    ),
                                                    icon: Icon(Icons.add), // Add icon here
                                                    label: Text('Add a second number'),
                                                  ),
                                                  SizedBox(height: 20),
                                                  Text(
                                                    'Attention! You can use 03(three).',
                                                    style: TextStyle(fontSize: 12, color: dark ? TColors.light : TColors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );

                                    },
                                    child: Icon(Iconsax.arrow_down_1), // Dropdown icon inside the text field
                                  ),
                                ),
                                initialCountryCode: 'CM',
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    const SizedBox(height: TSizes.spaceBtwSections),
                    const TAddressSection(isBillingAddress: false),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    const Divider(),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Obx(
                          () => CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text('Billing Address is Same as Shipping Address'.tr),
                        value: addressController.billingSameAsShipping.value,
                        onChanged: (value) => addressController.billingSameAsShipping.value = value ?? true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (subTotal <= 0) {
                TLoaders.warningSnackBar(title: 'Empty Cart'.tr, message: 'Add items in the cart in order to proceed.'.tr);
              } else if (selectedPaymentMethod.value.name == 'Mobile Money' && numberController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  TLoaders.warningSnackBar(title: 'Empty field'.tr, message: 'Add a payment number in order to proceed.'.tr),
                );
              } else {
                orderController.processOrder(subTotal);
                orderController.createData(
                  subTotal.toStringAsFixed(0),
                  selectedPaymentMethod.value.name == 'Mobile Money' ? "237${numberController.text}" : 'N/A',
                  selectedPaymentMethod.value.name,
                  'description'.tr,
                  context,
                );
              }
            },
            child: RichText(
              text: TextSpan(
                text: 'Confirm'.tr,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18.5),
                children: <TextSpan>[
                  TextSpan(text: ' ${checkoutController.getTotal(subTotal).toStringAsFixed(0)} FCFA'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodButton(PaymentMethodModel method) {
    return GestureDetector(
      onTap: () {
        selectedPaymentMethod.value = method;
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              method.image,
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 5),
          Obx(() => Text(
            method.name,
            style: TextStyle(
              fontSize: 10,
              fontWeight: selectedPaymentMethod.value.name == method.name ? FontWeight.bold : FontWeight.normal,
              color: selectedPaymentMethod.value.name == method.name ? TColors.primary : TColors.darkGrey,
            ),
          )),
        ],
      ),
    );
  }
}
