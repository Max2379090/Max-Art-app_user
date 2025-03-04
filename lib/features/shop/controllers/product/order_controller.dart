import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../common/widgets/success_screen/faild_screen.dart';
import '../../../../common/widgets/success_screen/success_payment.dart';
import '../../../../common/widgets/transaction_validation/transaction_validation.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../data/repositories/order/order_repository.dart';
import '../../../../home_menu.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../personalization/controllers/address_controller.dart';
import '../../models/order_model.dart';
import '../../screens/checkout/checkout.dart';
import '../../screens/payment_detail/payment_liste.dart';
import 'cart_controller.dart';
import 'checkout_controller.dart';
import 'product_controller.dart';

class OrderController extends GetxController {
  static OrderController get instance => Get.find();

  static const String token = 'Token 1519ea559097478bce64479d7b23777765a2d8d9';
  static const String baseUrl = 'https://demo.campay.net/api';
  static const Map<String, String> headers = {
    'Authorization': token,
    'Content-Type': 'application/json',
    'Cookie': 'csrftoken=GmN6Aq6a5ps4BF1zkzRI3lDlIoBaoCui'
  };


  /// Variables
  final cartController = CartController.instance;
  final addressController = AddressController.instance;
  final checkoutController = CheckoutController.instance;
  final orderRepository = Get.put(OrderRepository());
  final TextEditingController numberController = TextEditingController();
  final controller = CheckoutController.instance;


  /// Fetch user's order history
  Future<List<OrderModel>> fetchUserOrders() async {
    try {
      final userOrders = await orderRepository.fetchUserOrders();
      return userOrders;
    } catch (e) {
      TLoaders.warningSnackBar(title: 'Oh Snap!'.tr, message: e.toString());
      return [];
    }
  }

  /// Add methods for order processing
  void processOrder(double subTotal) async {
    try {
      // Start Loader

      TFullScreenLoader.openLoadingDialog(
          'Processing your order'.tr, TImages.pencilAnimation);


      // Get user authentication Id
      final userId = AuthenticationRepository.instance.getUserID;
      if (userId.isEmpty) return;

      if (addressController.billingSameAsShipping.isFalse) {
        if (addressController.selectedBillingAddress.value.id.isEmpty) {
          TLoaders.warningSnackBar(title: 'Billing Address Required'.tr,
              message: 'Please add Billing Address in order to proceed.'.tr);
          return;
        }
      }

      // Add Details
      final order = OrderModel(
        // Generate a unique ID for the order
        id: UniqueKey().toString(),
        userId: userId,
        status: OrderStatus.pending,
        totalAmount: checkoutController.getTotal(subTotal),
        orderDate: DateTime.now(),
        shippingAddress: addressController.selectedAddress.value,
        billingAddress: addressController.selectedBillingAddress.value,
        paymentMethod: checkoutController.selectedPaymentMethod.value.name,
        billingAddressSameAsShipping: addressController.billingSameAsShipping
            .value,
        deliveryDate: DateTime(DateTime
            .now()
            .year, DateTime
            .now()
            .month, DateTime
            .now()
            .day + 7),
        items: cartController.cartItems.toList(),
        shippingCost: checkoutController.getShippingCost(subTotal),
        taxCost: checkoutController.getTaxAmount(subTotal),
      );

      // Trigger payment gateway
      // if(checkoutController.selectedPaymentMethod.value.name == PaymentMethods.paypal.name) {
      //   final response = await TPaypalService.getPayment();
      //   print('Paypal Payment is ${response ? 'Successful' : 'Failed'}');
      //   if(response) TLoaders.successSnackBar(title: 'Congratulations', message: 'Paypal Payment Paid');
      //   if(!response) TLoaders.warningSnackBar(title: 'Failed', message: 'Paypal Payment Failed');
      // }

      // Save the order to Firestore
      await orderRepository.saveOrder(order, userId);

      // Once the order placed, update Stock of each item
      final productController = Get.put(ProductController());


      for (var product in cartController.cartItems) {
        await productController.updateProductStock(
            product.productId, product.quantity, product.variationId);
      }

      // Update the cart status
      cartController.clearCart();

      // Show Success screen
      Get.to(() =>
     TransactionValidation(title: 'Transaction Waiting Validation'.tr,
        subTitle: '*126# for MTN or #150*50# for ORANGE'.tr,
        subTitle2: 'Please do not leave this page...'.tr,)
      );

    } catch (e) {
      TLoaders.errorSnackBar(title: 'Oh Snap'.tr, message: e.toString());
    }
  }
// Reusable function to get transaction status
  Future<dynamic> getTransactionStatus(String referenceId) async {
    try {
      final url = Uri.parse('$baseUrl/transaction/$referenceId/');
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': response.reasonPhrase};
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

// Function to display a Snackbar
  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

// Function to create and initiate a transaction
  Future<void> createData(
      String subTotal,
      String phoneNumber,
      String  description,
      String operator,
      BuildContext context,
      ) async {
    final request = http.Request('POST', Uri.parse('$baseUrl/collect/'));

    request.body = json.encode({
      "amount":subTotal,
      "currency": "XAF",
      "from": phoneNumber,
      "description": description,
      "external_reference": "",
      "external_user": "",
    });
    request.headers.addAll(headers);

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseString = await response.stream.bytesToString();
        final responseData = json.decode(responseString);
        final transactionReference = responseData['reference'];

        // Check transaction status and navigate based on final status
        await _checkAndRecordTransaction(transactionReference, subTotal, phoneNumber, operator,description, context);
      } else {
        showSnackbar(context, 'Error: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      showSnackbar(context, 'Exception occurred: $e');
    }
  }

// Function to check and record transaction status in real time
  Future<void> _checkAndRecordTransaction(
      String transactionReference,
      String subTotal,
      String phoneNumber,
      String  description,
      String operator,
      BuildContext context,
      ) async {
    const int maxWaitTime = 25; // Maximum wait time in seconds
    const int interval = 2; // Check every 5 seconds
    int elapsed = 0; // Track elapsed time

    // Create a Firestore document reference
    final docRef = FirebaseFirestore.instance.collection('PaymentUser').doc(transactionReference);

    // Initial record with 'PENDING' status
    await docRef.set({
      "amount": subTotal,
      "currency": "XAF",
      "from": phoneNumber,
      "description": description,
      "transaction_reference": transactionReference,
      "status": "PENDING",
      "operator": operator,
      "created_at": FieldValue.serverTimestamp(),
    });

    while (elapsed < maxWaitTime) {
      await Future.delayed(const Duration(seconds: interval));
      elapsed += interval;

      final statusResponse = await getTransactionStatus(transactionReference);

      if (statusResponse is Map && statusResponse.containsKey('error')) {
        showSnackbar(context, 'Error checking status: ${statusResponse['error']}');
        return;
      }

      final status = statusResponse['status'];
      print('Status at $elapsed seconds: $status');

      // If the status is SUCCESSFUL, update the document, navigate to Success page
      if (status == 'SUCCESSFUL') {
        await docRef.update({
          "status": "SUCCESSFUL",
          "last_checked": FieldValue.serverTimestamp(),
        });

        showSnackbar(context, 'Transaction completed and saved.'.tr);

        // Navigate to Success page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>
              SuccessPayment(image: TImages.paymentSuccessfulAnimation, title: 'Payment Success!'.tr,  subTitle: 'Your payment has been successfully made, thank you for your trust.'.tr,
                onPressed: () => Get.offAll(() => const HomeMenu()),
                onPressed2: () => Get.offAll(() => PaymentListScreen(userId: 'Mk2sY0Tbw5Uo3PHEyPU4AMfEMHt2',)),),
          ),
        );
        return; // Stop further processing once SUCCESSFUL is confirmed
      }
    }

    // If status wasn't 'SUCCESSFUL' after all checks, display a failure message and navigate to Failed page
    showSnackbar(context, 'Transaction failed or still pending after $maxWaitTime seconds.');
    await docRef.update({"status": "FAILED"});

    // Navigate to Failed page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>
          FaildScreen(image: TImages.payment_failuret, title: 'Payment failure!'.tr, subTitle: 'Oops, something went wrong please try the transaction again!'.tr,
            onPressed: () => Get.offAll( () => const CheckoutScreen()), onPressed2: ()  => Get.offAll(() => const HomeMenu()),

          )),
    );
  }


  // Method to fetch real-time order status
  Stream<OrderModel> getRealTimeOrderStatus(String orderId) {
    try {
      return FirebaseFirestore.instance
          .collection('Orders') // Assuming orders are in this collection
          .doc(orderId)
          .snapshots() // Listen to real-time updates for this order document
          .map((documentSnapshot) {
        // If documentSnapshot exists, map to OrderModel
        if (documentSnapshot.exists) {
          return OrderModel.fromSnapshot(documentSnapshot);
        } else {
          throw 'Order not found';
        }
      });
    } catch (e) {
      throw 'Error fetching real-time order status: $e';
    }
  }
}