import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class TaxPaymentPage extends StatelessWidget {
  const TaxPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("List of services"),
        leading: IconButton(
          icon:Icon(Icons.arrow_back, color: dark ? TColors.light : TColors.black),
          onPressed: () {
            Navigator.pop(context); // Navigates back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Taxes",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Wrap GridView.builder inside Expanded
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1,
                ),
                itemCount: 2, // Number of services
                itemBuilder: (context, index) {
                  List<Map<String, String>> services = [
                    {
                      'image': 'assets/images/banners/unnamed.png',
                      'text': 'DOUANES',
                    },
                    {
                      'image': 'assets/images/banners/images copie.png',
                      'text': 'DGI IMPOTS',
                    },
                  ];

                  var service = services[index];

                  return GestureDetector(
                    onTap: () {
                      if (index == 0) {
                        _showDouaneBottomSheet(context);
                      } else {
                        _showDgiImpotBottomSheet(context);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              service['image']!,
                              width: 100,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Flexible(
                            child: Text(
                              service['text']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show Bottom Sheet for Douane
  void _showDouaneBottomSheet(BuildContext context) {
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
                          "Bill",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          "DOUANES",
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
                        const Text("Customs Duty Reference"),
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
                            "Please enter the reference of the customs duty customer want to pay",
                            style: TextStyle(fontSize: 10, color: TColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Continue"),
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
  }

  // Show Bottom Sheet for DGI IMPOTS
  void _showDgiImpotBottomSheet(BuildContext context) {
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
                          "Bill",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          "DGI IMPOT",
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
                        const Text("Reference No"),
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
                            "Please enter the Reference of the Tax Customer want to pay",
                            style: TextStyle(fontSize: 10, color: TColors.primary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Continue"),
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
  }
}
