import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_text_field/country_code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path/path.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  _TopUpScreenState createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final TextEditingController _amountController = TextEditingController();
  final String userId = "Mk2sY0Tbw5Uo3PHEyPU4AMfEMHt2"; // Replace with actual user ID
  String selectedPaymentMethod = 'Mobile Money';

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Top up your account",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [

                  const Text("Amount to add Max Store"),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      // Show the dialog when the icon is tapped
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Help Message"),
                            content: Text("Enter the amount you wish to recharge"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                child: Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.info,
                      size: 16,
                      color:dark ? TColors.light : TColors.black,
                    ),
                  ),
                ],),
              SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'FCFA',
                  labelText: 'FCFA',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  const Text("Pay With"),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      // Show the dialog when the icon is tapped
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Help Message"),
                            content: Text("Choose payment method"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                child: Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.info,
                      size: 16,
                      color:dark ? TColors.light : TColors.black,
                    ),
                  ),
                ],),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPaymentMethodButton('Mobile Money', 'assets/icons/payment_methods/orang_whiet_mtn.png'),
                  _buildPaymentMethodButton('Bank Card', 'assets/icons/payment_methods/master-card.png'),
                  _buildPaymentMethodButton('PayPal', 'assets/icons/payment_methods/paypal.png'),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  const Text("Phone Number"),
                  SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      // Show the dialog when the icon is tapped
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Help Message"),
                            content: Text("Enter your Mobil Money number"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                                child: Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.info,
                      size: 16,
                      color:dark ? TColors.light : TColors.black,
                    ),
                  ),
                  SizedBox(width:100),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min, // Makes it take only necessary space
                              children: [

                                Row(
                                  children: [
                                    const Text(
                                      "Add an",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      "additional number",
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Phone Number"),
                                    SizedBox(width: 5),
                                    GestureDetector(
                                      onTap: () {
                                        // Show the dialog when the icon is tapped
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Help Message"),
                                              content: Text("Please enter the Contract No or Bill No found on your ENEO Bill"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(); // Close the dialog
                                                  },
                                                  child: Text("OK"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Icon(
                                        Icons.info,
                                        size: 16,
                                        color:dark ? TColors.light : TColors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                CountryCodeTextField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Phone Number'.tr,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(),
                                    ),
                                  ),
                                  initialCountryCode: 'CM',
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text('Add'),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      width: 140,
                      height: 30,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color:Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color:dark ? TColors.light: TColors.primary,
                            size: 15,
                          ),
                          SizedBox(width: 2),
                          Text(
                            "Add a Number",
                            style: TextStyle(
                              color:dark ? TColors.light : TColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],),
              SizedBox(height: 10),
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
                          return Padding(
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
                                    Icon(Icons.cancel, color: Colors.grey[350],),
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

                                Text('Attention! You can use 03(three).',style: TextStyle(fontSize: 12, color:dark ? TColors.light : TColors.black,)),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Icon(Icons.arrow_drop_down), // Dropdown icon inside the text field
                  ),
                ),
                initialCountryCode: 'CM',
              ),


              SizedBox(height: 100),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSummaryRow('Top-up amount', '0 FCFA'),
                    _buildSummaryRow('Top-up fees', '0 FCFA'),
                    _buildSummaryRow('Total amount you will pay', '0 FCFA', isTotal: true),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  double? amount = double.tryParse(_amountController.text);
                  if (amount != null && amount > 0) {
                    await addToBalance(context, "Mk2sY0Tbw5Uo3PHEyPU4AMfEMHt2", amount);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please enter a valid amount")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethodButton(String method, String imagePath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPaymentMethod = method;
        });
      },
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              width: 70,
              height: 70,
              fit: BoxFit.contain,

            ),
          ),
          SizedBox(height: 5),
          Text(
            method,
            style: TextStyle(
              fontSize: 12,
              fontWeight: selectedPaymentMethod == method ? FontWeight.bold : FontWeight.normal,
              color: selectedPaymentMethod == method ? TColors.primary : TColors.darkGrey ,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal, color: isTotal ? TColors.primary : Colors.black)),
        ],
      ),
    );
  }
}

Future<void> addToBalance(BuildContext context, String userId, double amount) async {
  DocumentReference userRef =
  FirebaseFirestore.instance.collection('Users').doc(userId);

  return FirebaseFirestore.instance.runTransaction((transaction) async {
    DocumentSnapshot snapshot = await transaction.get(userRef);

    if (!snapshot.exists) {
      throw Exception("User does not exist!");
    }

    double currentBalance = (snapshot['balance'] is String)
        ? double.tryParse(snapshot['balance']) ?? 0.0
        : snapshot['balance'].toDouble();

    double newBalance = currentBalance + amount;

    transaction.update(userRef, {'balance': newBalance});
  }).then((_) {
    print("Balance updated successfully!");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Balance updated successfully!")),
    );
  }).catchError((error) {
    print("Failed to update balance: $error");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to update balance")),
    );
  });
}
