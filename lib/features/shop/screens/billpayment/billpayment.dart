import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../utils/constants/colors.dart';

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import 'option_payment/electricity_bill_page.dart';
import 'option_payment/tax_payment_page.dart';
import 'option_payment/tv_subscription_page.dart';
import 'option_payment/water_bill_page.dart';

// Import the pages for each bill type


class BillPaymentScreen extends StatelessWidget {
  const BillPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Row with Image and GridView
          Container(
            width: 500, // Full screen width (adjustable)
            height: 205, // Set height as required
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                // Image on the left side
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/images/banners/FACTURE2.png', // Replace with your image
                    fit: BoxFit.cover,
                    width: 150, // Fixed width for the image
                    height: 220, // Fixed height for the image
                  ),
                ),
                const SizedBox(width: 15), // Spacing between the image and GridView

                // GridView on the right side
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true, // Ensures GridView takes only necessary space
                    physics: const NeverScrollableScrollPhysics(), // Disables GridView scrolling
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Show two items per row
                      crossAxisSpacing: 10, // Spacing between items
                      mainAxisSpacing: 10, // Spacing between items
                      childAspectRatio: 1, // Adjust aspect ratio for smaller items
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final options = [
                        {'icon': Iconsax.lamp_charge, 'label': 'Electricity Bill', 'page': const ElectricityBillPage()},
                        {'icon': Icons.water_drop, 'label': 'Water Bill', 'page': const WaterBillPage()},
                        {'icon': Icons.tv, 'label': 'TV Subscription', 'page': const TvSubscriptionPage()},
                        {'icon': Iconsax.receipt_text, 'label': 'Pay Your Taxes', 'page': const TaxPaymentPage()},
                      ];
                      return PaymentOption(
                        icon: options[index]['icon'] as IconData,
                        label: options[index]['label'] as String,
                        destination: options[index]['page'] as Widget, // Pass destination page
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




class PaymentOption extends StatefulWidget {
  final IconData icon;
  final String label;
  final Widget destination;

  const PaymentOption({
    required this.icon,
    required this.label,
    required this.destination,
    super.key,
  });

  @override
  _PaymentOptionState createState() => _PaymentOptionState();
}

class _PaymentOptionState extends State<PaymentOption> {
  bool isLoading = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Start the timer to toggle shimmer every 20 seconds
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        isLoading = !isLoading; // Toggle the shimmer effect every 20 seconds
      });
    });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to prevent memory leaks
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget.destination),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12, width: 1),
          boxShadow: [
            const BoxShadow(color: Colors.black12, blurRadius: 4),
          ],
        ),
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Shimmer effect on the icon
            isLoading
                ? Shimmer.fromColors(
              baseColor:TColors.primary,
              highlightColor: Colors.grey[100]!,
              child: Icon(
                widget.icon,
                size: 60,
                color: TColors.primary,
              ),
            )
                : Icon(widget.icon, size: 60, color: TColors.primary),
            const SizedBox(height: 10),
            Text(
              widget.label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
