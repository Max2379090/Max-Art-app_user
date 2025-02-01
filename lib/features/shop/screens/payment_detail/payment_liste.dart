import 'package:Max_store/features/shop/screens/payment_detail/payment_detail.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';

class PaymentListScreen extends StatelessWidget {
  const PaymentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon:  Icon(Icons.arrow_back, color: isDark ?TColors.light : TColors.black,),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title:  Text('My Transactions'.tr, style: TextStyle(color: isDark ? TColors.light : TColors.black,),),
        centerTitle: true,
        backgroundColor: isDark ? TColors.black : TColors.light,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('PaymentUser')
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // Show loading spinner while waiting for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle errors if the snapshot fails
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong. Please try again.'.tr),
            );
          }

          // Check if the data is empty
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No payments found.'.tr),
            );
          }

          final payments = snapshot.data!.docs;

          return ListView.separated(
            itemCount: payments.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              var payment = payments[index].data() as Map<String, dynamic>;

              // Determine the status color
              Color statusColor =
              payment['status'] == 'SUCCESSFUL' ? Colors.green : Colors.red;

              // Format created_at timestamp
              DateTime createdAt =
              (payment['created_at'] as Timestamp).toDate();
              String formattedDate =
              DateFormat('yyyy-MM-dd – kk:mm').format(createdAt);

              return ListTile(
                leading: const Icon(Iconsax.wallet_money, color: Colors.green),
                title: Text(
                  'Amount: ${payment['amount']} ${payment['currency']}'.tr,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('From: ${payment['from']}'),
                    Text(
                      '${payment['status']}',
                      style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Created At: $formattedDate',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                trailing: Text(
                  payment['description'] ?? 'No description',
                  style: const TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  // Navigate to the Payment Detail Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentDetailScreen(payment: payment),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
