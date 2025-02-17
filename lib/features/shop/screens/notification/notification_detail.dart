import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';
// import '../../../../utils/popups/loaders.dart';

class NotificationDetailPage extends StatelessWidget {
  final String title;
  final String body;
  final String imageUrl;
  final String timestamp;
  final String targetScreen;

  const NotificationDetailPage({
    required this.title,
    required this.body,
    required this.imageUrl,
    required this.timestamp,
    required this.targetScreen,
    super.key,
  });

  void _handleNavigation(BuildContext context) {
    if (targetScreen.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No target screen specified'.tr),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      Get.toNamed(targetScreen);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navigation failed: ${e.toString()}'.tr),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildImage() {
    if (imageUrl.isEmpty) {
      return const Icon(Icons.notifications, size: 100);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        imageUrl,
        width: double.infinity,
        height: 350,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 350,
            color: Colors.grey[300],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 50),
                const SizedBox(height: 10),
                Text('Failed to load image'.tr),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? TColors.light : TColors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Notification Details'.tr,
          style: TextStyle(
            color: isDark ? TColors.light : TColors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: isDark ? TColors.black : TColors.light,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _handleNavigation(context),
                  child: _buildImage(),
                ),
                const SizedBox(height: 20),
                Text(
                  timestamp,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
                const SizedBox(height: 10),
                const Divider(),
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}