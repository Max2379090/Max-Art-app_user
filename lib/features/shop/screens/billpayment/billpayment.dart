import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';
import 'option_payment/electricity_bill_page.dart';
import 'option_payment/tax_payment_page.dart';
import 'option_payment/tv_subscription_page.dart';
import 'option_payment/water_bill_page.dart';

class BillPaymentScreen extends StatelessWidget {
  const BillPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage('assets/images/banners/FACTURE2.png'), // Replace with your image path
                  fit: BoxFit.cover, // Ensures the image covers the entire container
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                // First Row with GestureDetector for Navigation
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to the new page
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ElectricityBillPage()), // Replace 'ElectricityBillPage' with your target page widget
                          );
                        },
                        child: Container(
                          height: 90,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFFEAC5E), // Orange chaleureux
                                Color(0xFFC779D0), // Violet doux
                                Color(0xFF4BC0C8), // Bleu turquoise
                                Color(0xFF2E3192), // Bleu profond
                              ],
                              begin: Alignment.topLeft, // Point de départ du dégradé
                              end: Alignment.bottomRight, // Point de fin du dégradé
                              stops: [0.1, 0.4, 0.7, 1.0], // Position des couleurs dans le dégradé
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Stack(
                            alignment: Alignment.center, // Center the icon and text
                            children: [
                              Icon(
                                  Iconsax.lamp_charge,// Replace with the desired icon
                                size: 50, // Set the size of the icon
                                color: dark ? TColors.black: TColors.light, // Set the color of the icon
                              ),
                              Positioned(
                                bottom: 4, // Adjust position of the text if needed
                                child: Text(
                                  'Electricity Bill',
                                  style: TextStyle(
                                    color: dark ? TColors.black: TColors.light, // Text color
                                    fontSize: 8, // Adjusted text size for readability
                                    fontWeight: FontWeight.bold, // Optional text weight
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )

                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                          onTap: () {
                            // Navigate to the new page
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => WaterBillPage()), // Replace 'ElectricityBillPage' with your target page widget
                            );
                          },
                          child: Container(
                            height: 90,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFEAC5E), // Orange chaleureux
                                  Color(0xFFC779D0), // Violet doux
                                  Color(0xFF4BC0C8), // Bleu turquoise
                                  Color(0xFF2E3192), // Bleu profond
                                ],
                                begin: Alignment.topLeft, // Point de départ du dégradé
                                end: Alignment.bottomRight, // Point de fin du dégradé
                                stops: [0.1, 0.4, 0.7, 1.0], // Position des couleurs dans le dégradé
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              alignment: Alignment.center, // Center the icon and text
                              children: [
                                Icon(
                                  Icons.water_drop,// Replace with the desired icon
                                  size: 50, // Set the size of the icon
                                  color: dark ? TColors.black: TColors.light, // Set the color of the icon
                                ),
                                Positioned(
                                  bottom: 4, // Adjust position of the text if needed
                                  child: Text(
                                    'Water Bill',
                                    style: TextStyle(
                                      color: dark ? TColors.black: TColors.light, // Text color
                                      fontSize: 8, // Adjusted text size for readability
                                      fontWeight: FontWeight.bold, // Optional text weight
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )

                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Second Row with Payment Options
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                          onTap: () {
                            // Navigate to the new page
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TvSubscriptionPage()), // Replace 'ElectricityBillPage' with your target page widget
                            );
                          },
                          child: Container(
                            height: 90,

                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFEAC5E), // Orange chaleureux
                                  Color(0xFFC779D0), // Violet doux
                                  Color(0xFF4BC0C8), // Bleu turquoise
                                  Color(0xFF2E3192), // Bleu profond
                                ],
                                begin: Alignment.topLeft, // Point de départ du dégradé
                                end: Alignment.bottomRight, // Point de fin du dégradé
                                stops: [0.1, 0.4, 0.7, 1.0], // Position des couleurs dans le dégradé
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              alignment: Alignment.center, // Center the icon and text
                              children: [
                                Icon(
                                  Icons.tv, // Replace with the desired icon
                                  size: 50, // Set the size of the icon
                                  color: dark ? TColors.black: TColors.light, // Set the color of the icon
                                ),
                                Positioned(
                                  bottom: 4, // Adjust position of the text if needed
                                  child: Text(
                                    'TV Subscription',
                                    style: TextStyle(
                                      color: dark ? TColors.black: TColors.light, // Text color
                                      fontSize: 8, // Adjusted text size for readability
                                      fontWeight: FontWeight.bold, // Optional text weight
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )

                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                          onTap: () {
                            // Navigate to the new page
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TaxPaymentPage()), // Replace 'ElectricityBillPage' with your target page widget
                            );
                          },
                          child: Container(
                            height: 90,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFFEAC5E), // Orange chaleureux
                                  Color(0xFFC779D0), // Violet doux
                                  Color(0xFF4BC0C8), // Bleu turquoise
                                  Color(0xFF2E3192), // Bleu profond
                                ],
                                begin: Alignment.topLeft, // Point de départ du dégradé
                                end: Alignment.bottomRight, // Point de fin du dégradé
                                stops: [0.1, 0.4, 0.7, 1.0], // Position des couleurs dans le dégradé
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              alignment: Alignment.center, // Center the icon and text
                              children: [
                                Icon(
                                  Iconsax.receipt_text, // Replace with the desired icon
                                  size: 50, // Set the size of the icon
                                  color: dark ? TColors.black: TColors.light, // Set the color of the icon
                                ),
                                Positioned(
                                  bottom: 4, // Adjust position of the text if needed
                                  child: Text(
                                    'Pay Your Taxes',
                                    style: TextStyle(
                                      color: dark ? TColors.black: TColors.light, // Text color
                                      fontSize: 8, // Adjusted text size for readability
                                      fontWeight: FontWeight.bold, // Optional text weight
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )

                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentOption extends StatelessWidget {
  final String icon;
  final String label;

  const PaymentOption({required this.icon, required this.label});

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
              baseColor:TColors.primary!,
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
