import 'package:flutter/material.dart';

class TvSubscriptionPage extends StatelessWidget {
  const TvSubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List of services"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
                  childAspectRatio: 1, // Adjust aspect ratio
                ),
                itemCount: 3, // Set item count to 3
                itemBuilder: (context, index) {
                  // Use a list or switch for different services
                  List<Map<String, String>> services = [
                    {
                      'image': 'assets/images/banners/new_dstv_logo.png', // Service 1 image
                      'text': 'DSTV', // Service 1 text
                    },
                    {
                      'image': 'assets/images/banners/StarTimes_B2C-02_(2).png', // Service 2 image
                      'text': 'StarTimes', // Service 2 text
                    },
                    {
                      'image': 'assets/images/banners/Canal_logo.png', // Service 3 image
                      'text': 'CanalPlus', // Service 3 text
                    },
                  ];

                  // Access each service data based on index
                  var service = services[index];

                  return GestureDetector(
                    onTap: () {
                      // Navigate to details or payment page
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
                              service['image']!, // Dynamically set image
                              width: 110,
                            ),
                          ),
                          const SizedBox(height: 10), // Space between image and text
                          Text(
                            service['text']!, // Dynamically set text
                            style: const TextStyle(
                              fontSize: 11, // Adjust this value to change the size
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
}
