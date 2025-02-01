import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart'; // Assuming you are using GetX for navigation

class NotificationDetailPage extends StatelessWidget {
  final String title;
  final String body;
  final String imageUrl;
  final String timestamp;
  final String targetScreen; // Add targetScreen parameter

  // Constructor to accept the data from the Notifications page
  const NotificationDetailPage({
    required this.title,
    required this.body,
    required this.imageUrl,
    required this.timestamp,
    required this.targetScreen, // Accept targetScreen
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          icon:  Icon(Icons.arrow_back, color: isDark ?TColors.light : TColors.black,),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title:  Text('Notification Details'.tr, style: TextStyle(color: isDark ? TColors.light : TColors.black,),),
        centerTitle: true,
        backgroundColor: isDark ? TColors.black : TColors.light,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                if (targetScreen.isNotEmpty) {
                  Get.toNamed(targetScreen); // Navigate to targetScreen
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No target screen specified'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: imageUrl.isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 500,
                  height: 350,
                  fit: BoxFit.cover,
                ),
              )
                  : const Icon(Icons.notifications, size: 100),
            ),
            const SizedBox(height: 20),
            Text(
              timestamp,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 10),
            const Divider(),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 10),
            Text(body),
          ],
        ),
      ),
    );
  }
}
