import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';
class StartimesPage extends StatelessWidget {
  StartimesPage({super.key});

  final List<Map<String, String>> subscriptions = [
    {"title": "STARTIMES SUPER-FR 9000", "price": "9000 XAF"},
    {"title": "STARTIMES SUPER-EN 9000", "price": "9000 XAF"},
    {"title": "STARTIMES SUPER-CHINOIS 13500", "price": "13500 XAF"},
    {"title": "STARTIMES MAX 10500", "price": "10500 XAF"},
    {"title": "STARTIMES SMART 5000", "price": "5000 XAF"},

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("StarTimes"),
                const SizedBox(height: 40), // Space between texts
              ],
            ),
            Text("StarTimes Monthly Subscription", style: TextStyle(fontSize: 13.5, color: Colors.grey[350])),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: subscriptions.length,
                itemBuilder: (context, index) {
                  final item = subscriptions[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/banners/startimescameroun_logo.jpg',
                        width: 50,
                        height: 50,
                      ),
                    ),
                    title: Text(
                      item['title']!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(item['price']!),
                    trailing: Text(
                      '${item['price']!.split(' ')[0]} F',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isDismissible: true,
                        isScrollControlled: true,
                        backgroundColor: Colors.white,
                        builder: (builder) {
                          return FractionallySizedBox(
                            heightFactor: 0.6,
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: SingleChildScrollView(
                                child: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
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
                                            "StarTimes",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: TColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 40),
                                      Row(
                                        children: [
                                          const Text("Subscription Number"),
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
                                            decoration: InputDecoration(
                                              hintText: "Fill in the field",
                                              border: OutlineInputBorder(),
                                              filled: true, // Enables background color
                                              fillColor: Colors.grey[300], // Light grey background
                                            ),
                                            keyboardType: TextInputType.text,
                                            obscureText: false,
                                            maxLines: 1,
                                            style: TextStyle(fontSize: 16, color: Colors.black),
                                            onChanged: (value) {
                                              print("User typed: $value");
                                            },
                                          )
                                      ),


                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          const Text("Selected plan"),
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
                                                    'assets/images/banners/startimescameroun_logo.jpg', // Replace with your image URL
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
                                          )

                                      ),
                                      const SizedBox(height: 10),
                                      Center(
                                          child: Container(
                                            width: 190, // Set the width of the container
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
                                      //const SizedBox(height: 10),

                                      //Row(
                                        //children: [
                                         // const Text(
                                         //   "NOTE:",
                                         //   style: TextStyle(
                                         //     fontSize: 10,
                                          //    fontWeight: FontWeight.w700,
                                           //   color: TColors.primary,
                                           // ),
                                         // ),
                                         // const SizedBox(width: 8),
                                         // Expanded(
                                           // child: const Text(
                                           //   "Please enter the DSTV Card Number (10 gigits)",
                                          //    style: TextStyle(fontSize: 10, color: TColors.primary),
                                          //  ),
                                        //  ),
                                        //],
                                     // ),
                                      const SizedBox(height: 40),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 60,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Confirm"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );

                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
