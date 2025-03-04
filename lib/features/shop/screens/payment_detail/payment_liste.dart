import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';

class PaymentListScreen extends StatelessWidget {
  final String userId;

  PaymentListScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
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
          "My Transactions",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('PaymentUser')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No transactions available"));
          }

          var transactions = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              var transaction = transactions[index].data() as Map<String, dynamic>;
              String transactionId = transactions[index].id; // Get Transaction ID

              // Format created_at timestamp
              DateTime createdAt = (transaction['created_at'] as Timestamp).toDate();
              String formattedDate = DateFormat('dd MMMM yyyy – HH:mm',).format(createdAt);

              return Card(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  leading: Icon(
                    Icons.arrow_downward,
                    color: transaction['status'] == 'Failed' ? Colors.red : Colors.green,
                  ),
                  title: Text(transaction['title'] ?? 'Account top-up',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13.5, color: dark ? TColors.light : TColors.black,),),
                  subtitle: Text('Date: $formattedDate\nMS$transactionId',style: TextStyle(fontSize: 11, color:Colors.grey),),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '+${(transaction['amount'] as num).toStringAsFixed(0)} FCFA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                          color: transaction['status'] == 'Failed' ? Colors.red : Colors.green,
                        ),
                      ),
                      SizedBox(height: 18,),
                      Text(
                        transaction['status'] ?? 'Unknown',
                        style: TextStyle(
                          color: transaction['status'] == 'Failed' ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
