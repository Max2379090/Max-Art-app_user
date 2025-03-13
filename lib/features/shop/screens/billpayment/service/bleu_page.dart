import 'package:country_code_text_field/country_code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/colors.dart';



class BleuPage extends StatelessWidget {
  BleuPage({super.key});

  final List<Map<String, String>> subscriptions = [
    {"title": "Aitime 500 XAF", "price": "500 XAF"},
    {"title": "Aitime 200 XAF", "price": "200 XAF"},
    {"title": "Aitime 100 XAF", "price": "100 XAF"},


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
                const Text("CAMTEL Recharge/Topup"),
                const SizedBox(height: 40), // Space between texts
              ],
            ),
            Text("Camtel communication credit recharge", style: TextStyle(fontSize: 13.5, color: Colors.grey[350])),
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
                        'assets/images/banners/BLEU_logo copie.jpg',
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
                                            "Top up",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          const Text(
                                            "CAMTEL",
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
                                          const Text("CAMTEL Number"),
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
                                        child: CountryCodeTextField(
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: 'Phone Number'.tr,
                                            border: const OutlineInputBorder(
                                              borderSide: BorderSide(),
                                            ),
                                          ),
                                          initialCountryCode: 'CM',
                                        ),

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
                                                    'assets/images/banners/BLEU_logo copie.jpg', // Replace with your image URL
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
                                            width: 170, // Set the width of the container
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
                                                      Text('0 FCFA',style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold,color: TColors.primary
                                                      ),)
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )

                                      ),
                                      const SizedBox(height: 10),

                                      Center(
                                        child: Row(
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
                                                "Please enter phone number in the format 24#######",
                                                style: TextStyle(fontSize: 10, color: TColors.primary),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
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
