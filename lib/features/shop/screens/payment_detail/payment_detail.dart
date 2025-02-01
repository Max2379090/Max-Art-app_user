
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../utils/constants/colors.dart';

class PaymentDetailScreen extends StatelessWidget {
  final Map<String, dynamic> payment;

  const PaymentDetailScreen({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    Color statusColor = payment['status'] == 'SUCCESSFUL' ? Colors.green : Colors.red;

    // Format the created_at timestamp
    DateTime createdAt = (payment['created_at'] as Timestamp).toDate();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(createdAt);

    // Determine operator logo and color
    String operator = payment['operator'] ?? '';
    String operatorLogo = 'assets/icons/payment_methods/orange_money.png';
    Color operatorColor = Colors.black;

    if (operator.toUpperCase() == 'ORANGE') {
      operatorLogo = 'assets/icons/payment_methods/orange_money.png'; // Orange logo
      operatorColor = Colors.deepOrange;
    } else if (operator.toUpperCase() == 'MTN') {
      operatorLogo = 'assets/icons/payment_methods/mtn_momo.png'; // MTN logo
      operatorColor = const Color(0xFFF9A825);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title:Text('Transactions details'.tr, style: const TextStyle(color: Colors.black),),
        centerTitle: true,
        backgroundColor: TColors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Section with left and right alignment
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Amount',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${payment['amount']} ${payment['currency']}',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1, color: Colors.grey),
            const SizedBox(height: 10),

            // From Section with left and right alignment
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'From',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  payment['from'],
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1, color: Colors.grey),
            const SizedBox(height: 10),

            // Operator Section with color and logo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  operatorLogo,
                  width: 30,
                  height: 30,
                ),
                const SizedBox(width: 10),
                Text(
                  operator,
                  style: TextStyle(fontSize: 18, color: operatorColor),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1, color: Colors.grey),
            const SizedBox(height: 10),

            // Status Section with left and right alignment
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Status',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  payment['status'],
                  style: TextStyle(fontSize: 18, color: statusColor),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1, color: Colors.grey),
            const SizedBox(height: 10),

            // Created At Section with left and right alignment
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Created At',
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  formattedDate,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1, color: Colors.grey),
            const SizedBox(height: 10),

            // Description Section
            Text(
              'Description ${payment['description'] ?? 'No description available.'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),

            // Close Button
            Center(
              child: SizedBox(
                width: 150, // Set the desired width
                height: 60, // Set the desired height
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Close'.tr),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
