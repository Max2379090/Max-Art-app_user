import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../service/dstv_page.dart';
import '../service/startime_page.dart';
import '../service/canalplus_page.dart';

class TvSubscriptionPage extends StatelessWidget {
  const TvSubscriptionPage({super.key});

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
              "Tv Subscription",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Wrap GridView.builder inside Expanded
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Adjust number of columns as needed
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.9, // Adjust aspect ratio
                ),
                itemCount: 3, // Set item count to 3
                itemBuilder: (context, index) {
                  // List of services with their corresponding navigation routes
                  List<Map<String, dynamic>> services = [
                    {
                      'image': 'assets/images/banners/new_dstv_logo.png',
                      'text': 'DSTV',
                      'route': DSTVPage(), // Navigate to DSTV page
                    },
                    {
                      'image': 'assets/images/banners/StarTimes_B2C-02_(2).png',
                      'text': 'StarTimes',
                      'route': StartimesPage(), // Navigate to StarTimes page
                    },
                    {
                      'image': 'assets/images/banners/Canal_logo.png',
                      'text': 'CanalPlus',
                      'route': CanalplusPage(), // Navigate to CanalPlus page
                    },
                  ];

                  var service = services[index];

                  return GestureDetector(
                    onTap: () {
                      Get.to(service['route']); // Navigate using Get.to()
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
                              width: 110,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Flexible(
                            child: Text(
                              service['text']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500),
                            ),
                          )
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
}

// Placeholder pages for each service



