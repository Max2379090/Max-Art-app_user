import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../contact_us/contact_us.dart';
// Import the detail page

class HistoryPage extends StatelessWidget {
  final String userId;

  const HistoryPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        backgroundColor: Color(0xFFEEEEEE),
        appBar: AppBar(
          backgroundColor: TColors.primary,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "My Transactions".tr,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: TabBar(
              tabs: [
                Tab(text: 'Wallet'),
                Tab(text: 'Order'),
                Tab(text: 'Bill'),
                Tab(text: 'Service'),
              ],
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicatorWeight: 5.0,
              labelStyle: TextStyle(fontSize: 15),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // Tab 1 - Wallet content
            _buildTransactionTab(
              context,
              'PaymentUser',
              Iconsax.wallet,
              'Account top-up',
                  (transaction) => TransactionDetailPage(transaction: transaction),
            ),
            // Tab 2 - Order content
            _buildTransactionTab(
              context,
              'Transactions',
              Iconsax.shopping_cart,
              'Order',
                  (transaction) => TransactionDetailPage(transaction: transaction),
            ),
            // Tab 3 - Bill content
            _buildTransactionTab(
              context,
              'Bills',
              Iconsax.receipt,
              'Bills',
                  (transaction) => TransactionDetailPage(transaction: transaction),
            ),
            // Tab 4 - Service content
            _buildTransactionTab(
              context,
              'Services',
              Iconsax.ticket,
              'Services',
                  (transaction) => TransactionDetailPage(transaction: transaction),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create each tab content
  Widget _buildTransactionTab(BuildContext context, String collection, IconData icon, String title, Widget Function(Map<String, dynamic>) onTap) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection(collection)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong!'));
        }

        final transactions = snapshot.data?.docs ?? [];
        final dark = THelperFunctions.isDarkMode(context);
        return ListView.builder(
          padding: EdgeInsets.all(0),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            var transaction = transactions[index].data() as Map<String, dynamic>;
            String transactionId = transactions[index].id;
            DateTime createdAt = (transaction['created_at'] as Timestamp?)?.toDate() ?? DateTime.now();
            String formattedDate = DateFormat('dd MMMM yyyy – HH:mm').format(createdAt);

            return GestureDetector(
              onTap: () {
                // Navigate to the detailed transaction page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => onTap(transaction),
                  ),
                );
              },
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                elevation: 5,
                child: ListTile(
                  title: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.5,
                      color: dark ? TColors.light : TColors.black,
                    ),
                  ),
                  subtitle: Text(
                    '$formattedDate\nMS$transactionId',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  leading: Icon(icon),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '+${(transaction['amount'])} FCFA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                          color: transaction['status'] == 'Failed' ? Colors.red : Colors.green,
                        ),
                      ),
                      SizedBox(height: 18),
                      Text(
                        transaction['status'] ?? 'Unknown',
                        style: TextStyle(
                          color: transaction['status'] == 'Failed' ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class TransactionDetailPage extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const TransactionDetailPage({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    DateTime createdAt = (transaction['created_at'] as Timestamp?)?.toDate() ?? DateTime.now();
    String formattedDate = DateFormat('dd MMMM yyyy – HH:mm').format(createdAt);

    // Determine status color
    Color statusColor = transaction['status'] == 'Failed' ? Colors.red : Colors.green;

    return Scaffold(
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
          "Transaction Details".tr,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildStatus(transaction['status'], statusColor),
            Divider(),
            const SizedBox(height: 35),
            _buildDetailRow("Date", formattedDate),
            Divider(),
            const SizedBox(height: 35),
            _buildDetailRow("Amount", "${transaction['amount']} FCFA"),
            Divider(),
            const SizedBox(height: 35),
            _buildDetailRow("Transaction ID", "MS${transaction['id']}"),

            Divider(),
            const SizedBox(height: 35),
            _buildDetailRow("Description", transaction['details'] ?? 'No details available'),
            Divider(),
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildStatus(String status, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Status", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: () {},
          icon: const Icon(Icons.download, color: Colors.white),
          label: const Text("Download Receipt", style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: TColors.primary,
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: () => Get.to(() =>  SupportScreen()),

          icon: const Icon(Icons.support_agent, color: TColors.white),
          label: const Text("Report to Customer Support", style: TextStyle(color: TColors.white)),
        ),
      ],
    );
  }
}
