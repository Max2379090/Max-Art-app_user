import 'dart:convert';
import 'dart:typed_data';
import 'package:Max_store/api/firebase_api.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../../utils/popups/loaders.dart';
import 'notification_detail.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationState();
}

class _NotificationState extends State<Notifications> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotifications();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      String title = message.notification?.title ?? 'No Title';
      String body = message.notification?.body ?? 'No Body';
      String imageUrl = message.data['image_url'] ?? '';
      String targetScreen = message.data['target_screen'] ?? '';

      showNotification(title, body, imageUrl);
      saveNotificationToFirestore(title, body, imageUrl: imageUrl, targetScreen: targetScreen);
    });
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('notification_icon');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          print('Notification Payload: ${response.payload}');
        }
      },
    );
  }

  Future<void> showNotification(String title, String body, String? imageUrl) async {
    BigPictureStyleInformation? bigPictureStyleInformation;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      bigPictureStyleInformation = BigPictureStyleInformation(
        ByteArrayAndroidBitmap.fromBase64String(imageUrl),
        contentTitle: title,
        summaryText: body,
      );
    }

      final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'product_updates_channel',
        'Product Updates',
        channelDescription: 'Channel for product updates notifications',
        importance: Importance.high,
        priority: Priority.high,
        styleInformation: bigPictureStyleInformation,
        enableVibration: true,
        groupKey: 'product_updates_group',
        setAsGroupSummary: true,
        groupAlertBehavior: GroupAlertBehavior.all,
        vibrationPattern: Int64List.fromList([0, 500, 1000, 500]),
        icon: '@mipmap/ic_launcher', // CHANGED HERE
        sound: const RawResourceAndroidNotificationSound('notification_sound'),
      );

      final NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

      await _notificationsPlugin.show(
        DateTime.now().millisecond,
        title,
        body,
        platformDetails,
        payload: json.encode({
          'title': title,
          'body': body,
          'imageUrl': base64Image,
        }),
      );
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  Future<void> _saveNotificationToFirestore({
    required String title,
    required String body,
    String? imageUrl,
    String? targetScreen,
  }) async {
    try {
      final Map<String, dynamic> notificationData = {
        'title': title,
        'body': body,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
        'targetScreen': targetScreen ?? '',
        if (imageUrl != null && imageUrl.isNotEmpty) 'imageUrl': imageUrl,
      };

      await _firestore.collection('Notifications').add(notificationData);
    } catch (e) {
      debugPrint('Error saving notification: $e');
      TLoaders.errorSnackBar(
        title: 'Error'.tr,
        message: 'Failed to save notification'.tr,
      );
    }
  }

  Future<void> _deleteNotification(String docId) async {
    try {
      await _firestore.collection('Notifications').doc(docId).delete();
      TLoaders.successSnackBar(
        title: 'Success'.tr,
        message: 'Notification deleted successfully'.tr,
      );
    } catch (e) {
      debugPrint('Error deleting notification: $e');
      TLoaders.errorSnackBar(
        title: 'Error'.tr,
        message: 'Failed to delete notification'.tr,
      );
    }
  }

  Future<void> _markAsRead(String docId) async {
    try {
      await _firestore.collection('Notifications').doc(docId).update({'isRead': true});
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    final DateTime date = timestamp.toDate();
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} "
        "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);

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
          "Notifications".tr,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('Notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading notifications'.tr),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications yet'.tr,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final notification = doc.data() as Map<String, dynamic>;

              final String title = notification['title'] ?? 'No Title';
              final String body = notification['body'] ?? 'No Body';
              final String imageUrl = notification['imageUrl'] ?? '';
              final String targetScreen = notification['targetScreen'] ?? '';
              final bool isRead = notification['isRead'] ?? false;
              final String formattedTimestamp = notification['timestamp'] != null
                  ? _formatTimestamp(notification['timestamp'] as Timestamp)
                  : 'Unknown Date';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (targetScreen.isNotEmpty) {
                            Navigator.pushNamed(context, targetScreen);
                          }
                        },
                        child: imageUrl.isNotEmpty
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            width: 90,
                            height:100,
                            fit: BoxFit.cover,
                          ),
                        )
                            : const Icon(Icons.notifications, size: 40),
                      ),
                      if (!isRead)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              color: TColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Text(
                              body,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 50),
                      Text(
                        formattedTimestamp,
                        style: const TextStyle(color: Colors.grey, fontSize: 10),
                      ),],
                  ),
                  onTap: () async {
                    await FirebaseFirestore.instance
                        .collection('Notifications')
                        .doc(docId)
                        .update({'isRead': true});

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationDetailPage(
                          title: title,
                          body: body,
                          imageUrl: imageUrl,
                          timestamp: formattedTimestamp,
                          targetScreen: targetScreen,
                        ),
                      );
                    },
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

class _NotificationImage extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onTap;

  const _NotificationImage({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return const Icon(Icons.notifications, size: 40);
    }

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          width: 90,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.notifications, size: 40);
          },
        ),
      ),
    );
  }
}

class _UnreadIndicator extends StatelessWidget {
  const _UnreadIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: const BoxDecoration(
        color: TColors.primary,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _NotificationImage extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onTap;

  const _NotificationImage({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return const Icon(Icons.notifications, size: 40);
    }

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          width: 90,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.notifications, size: 40);
          },
        ),
      ),
    );
  }
}

class _UnreadIndicator extends StatelessWidget {
  const _UnreadIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: const BoxDecoration(
        color: TColors.primary,
        shape: BoxShape.circle,
      ),
    );
  }
}