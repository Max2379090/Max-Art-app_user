import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/success_screen/success_payment.dart';
import '../../../../../home_menu.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/popups/loaders.dart';
import '../../payment_detail/payment_liste.dart';

class CanalplusPage extends StatefulWidget {
  const CanalplusPage({super.key});

  @override
  State<CanalplusPage> createState() => _CanalplusPageState();
}

class _CanalplusPageState extends State<CanalplusPage> {
  final TextEditingController canalCodeController = TextEditingController();
  final String userId = 'Mk2sY0Tbw5Uo3PHEyPU4AMfEMHt2';

  final List<Map<String, String>> subscriptions = [
    {"title": "ACCES + CHARME", "price": "12000 XAF"},
    {"title": "ACCES + 1-MOIS", "price": "15000 XAF"},
    {"title": "TOUT CANAL+ 6-MOIS", "price": "270000 XAF"},
    {"title": "TOUT CANAL+ 3-MOIS", "price": "135000 XAF"},
    {"title": "TOUT CANAL+ 1-MOIS", "price": "45000 XAF"},
    {"title": "EVASION+ 6-MOIS", "price": "135000 XAF"},
    {"title": "EVASION+ 3-MOIS", "price": "67500 XAF"},
    {"title": "EVASION+ 1-MOIS", "price": "22500 XAF"},
    {"title": "EVASION-6-MOIS", "price": "60000 XAF"},
    {"title": "EVASION-3-MOIS", "price": "30000 XAF"},
    {"title": "EVASION-1-MOIS", "price": "10000 XAF"},
    {"title": "ACCES-6-MOIS", "price": "30000 XAF"},
    {"title": "ACCES-1-MOIS", "price": "5000 XAF"},
  ];

  @override
  void dispose() {
    canalCodeController.dispose();
    super.dispose();
  }

  Future<double> getUserBalance() async {
    var userDoc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    if (!userDoc.exists) return 0.0;
    return (userDoc['balance'] as num).toDouble();
  }

  void processPayment(BuildContext context, Map<String, String> item) async {
    String canalCode = canalCodeController.text.trim();
    if (canalCode.length != 14) {
      TLoaders.errorSnackBar(
        title: 'Error'.tr,
        message: 'Please enter a valid 14-digit Canal+ code.'.tr,
      );
      return;
    }

    double balance = await getUserBalance();
    double? price = double.tryParse(item['price']!.split(' ')[0]);

    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Invalid price format.")));
      return;
    }

    if (balance < price) {
      TLoaders.warningSnackBar(
        title: 'Insufficient Balance'.tr,
        message: 'You do not have enough balance to complete this purchase.'.tr,
      );
      return;
    }

    await FirebaseFirestore.instance.collection('Users').doc(userId).update({
      'balance': balance - price,
    });

    await FirebaseFirestore.instance.collection('Users').doc(userId).collection('Bills').add({
      'userId': userId,
      'amount': '$price FCFA',
      'paymentMethod': 'Wallet Max Store',
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'Successful',
      'description': 'Canal+ Subscription: ${item['title']}',
      'Decoder Number': canalCodeController.text,
    });

    Get.offAll(() => SuccessPayment(
      image: TImages.paymentSuccessfulAnimation,
      title: 'Payment Success!'.tr,
      subTitle: 'Your payment has been successfully made, thank you for your trust.'.tr,
      onPressed: () => Get.offAll(() => const HomeMenu()),
      onPressed2: () => Get.offAll(() => HistoryPage(userId: 'Mk2sY0Tbw5Uo3PHEyPU4AMfEMHt2')),
    ));
    //TLoaders.successSnackBar(
    //  title: 'Payment Successful'.tr,
     // message: 'Your payment has been processed successfully.'.tr,
   // );
  }

  void showPaymentModal(BuildContext context, Map<String, String> item) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (builder) {
        return FractionallySizedBox(
          heightFactor: 0.6,
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Product",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          "Canal+",
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
                        const Text("Enter 14-digit Canal+ code"),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            // Show the dialog when the icon is tapped
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Help Message"),
                                  content: Text("Fill in the field"),
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
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200], // Background color
                          borderRadius: BorderRadius.circular(8), // Rounded corners
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          controller: canalCodeController,
                          decoration: InputDecoration(
                            hintText: "Fill in the field",
                            border: OutlineInputBorder(),
                            filled: true, // Enables background color
                            fillColor: Colors.grey[300],
                            // Light grey background
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 14,
                          obscureText: false,
                          maxLines: 1,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          onChanged: (value) {
                            print("User typed: $value");
                          },
                        )
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text("Selected plan"),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            // Show the dialog when the icon is tapped
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Help Message"),
                                  content: Text("Subscribed Package"),
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
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Center(
                        child: Container(
                          width: 360, // Set the width of the container
                          height: 120, // Set the height of the container
                          decoration: BoxDecoration(
                            color: Colors.grey[300], // Background color
                            borderRadius: BorderRadius.circular(15), // Rounded corners
                          ),
                          padding: EdgeInsets.all(10), // Padding inside the container
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10), // Make image round
                                child: Image.asset(
                                  'assets/images/banners/CANAL+LOGO.png', // Replace with your image URL
                                  width: 70, // Set width for the image
                                  height: 70, // Set height for the image
                                  fit: BoxFit.cover, // Ensure the image covers the area
                                ),
                              ),
                              SizedBox(width: 15), // Add spacing between image and text
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item['title']!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(item['price']!)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ),
                    SizedBox(height: 10),
                    Center(
                        child: Container(
                          width: 250,
                          height: 35, // Set the height of the container
                          decoration: BoxDecoration(
                            color: Colors.grey[300], // Background color
                            borderRadius: BorderRadius.circular(15), // Rounded corners
                          ),
                          padding: EdgeInsets.all(10), // Padding inside the container
                          child: Row(
                            children: [
                              // Add spacing between image and text
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Your balance:',style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                    const SizedBox(width: 5),
                                    StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance.collection('Users').doc('Mk2sY0Tbw5Uo3PHEyPU4AMfEMHt2').snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState == ConnectionState.waiting) {
                                          return CircularProgressIndicator(color: Colors.white);
                                        }
                                        if (!snapshot.hasData || !snapshot.data!.exists) {
                                          return Text(
                                            "0 F CFA",
                                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: TColors.primary),
                                          );
                                        }

                                        var data = snapshot.data!;
                                        double balance = (data['balance'] is String)
                                            ? double.tryParse(data['balance']) ?? 0.0
                                            : (data['balance'] as num).toDouble();

                                        return Text(
                                          "${balance.toStringAsFixed(0)} F CFA",
                                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: TColors.primary),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )

                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: [
                        const Text(
                          "NOTE:",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: TColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: const Text(
                            "Please enter the Canal+ Decoder Number (14 digits)",
                            style: TextStyle(fontSize: 10, color: TColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () async {
                        // Show the loading indicator
                        showDialog(
                          context: context,
                          barrierDismissible: false, // Prevent closing by tapping outside
                          builder: (BuildContext context) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );

                        // Simulate a payment process that takes 3 seconds
                        await Future.delayed(Duration(seconds: 3));

                        // Perform payment processing
                        processPayment(context, item);

                        // Close the loading dialog
                        Navigator.of(context, rootNavigator: true).pop();

                        // Show the success screen

                      },
                      style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
                      child: Text("Confirm Payment"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("CanalPlus"),
            Text("Monthly Renewal for TV cable", style: TextStyle(fontSize: 13.5, color: Colors.grey[350])),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: subscriptions.length,
          itemBuilder: (context, index) {
            final item = subscriptions[index];
            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/banners/CANAL+LOGO.png',
                  width: 50,
                  height: 50,
                ),
              ),
              title: Text(item['title']!, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item['price']!),
              trailing: Text('${item['price']!.split(' ')[0]} F', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              onTap: () => showPaymentModal(context, item),
            );
          },
        ),
      ),
    );
  }
}
