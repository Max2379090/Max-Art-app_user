import 'dart:typed_data';
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
  _NotificationState createState() => _NotificationState();
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
      vibrationPattern: Int64List.fromList([0, 500, 1000, 500]),
    );

    final NotificationDetails platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformDetails,
      payload: 'Notification payload',
    );
  }

  Future<void> saveNotificationToFirestore(
      String title,
      String body, {
        String? imageUrl,
        String? targetScreen,
      }) async {
    try {
      Map<String, dynamic> notificationData = {
        'title': title,
        'body': body,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
        'targetScreen': targetScreen,
      };

      if (imageUrl != null && imageUrl.isNotEmpty) {
        notificationData['imageUrl'] = imageUrl;
      }

      await FirebaseFirestore.instance.collection('Notifications').add(notificationData);
      showNotification(title, body, imageUrl);
    } catch (e) {
      print('Error saving notification: $e');
    }
  }

  Stream<QuerySnapshot> fetchNotifications() {
    return FirebaseFirestore.instance
        .collection('Notifications')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> deleteNotification(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('Notifications').doc(docId).delete();
      TLoaders.successSnackBar(title: 'Notifications'.tr, message: 'Notification deleted successfully'.tr);
    } catch (e) {
      TLoaders.warningSnackBar(title: 'Notifications'.tr, message: 'Failed to delete notification'.tr);
    }
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
  }

  /// Helper function to safely parse a timestamp from either a string or Timestamp
  Timestamp? parseTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp;
    } else if (timestamp is String) {
      try {
        return Timestamp.fromDate(DateTime.parse(timestamp));
      } catch (e) {
        print('Error converting String to Timestamp: $e');
        return null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
    leading: IconButton(
    icon:  Icon(Icons.arrow_back, color: isDark ?TColors.light : TColors.black,),
    onPressed: () => Navigator.of(context).pop(),
    ),
    title:  Text('Notifications'.tr, style: TextStyle(color: isDark ? TColors.light : TColors.black,),),
    centerTitle: true,
    backgroundColor: isDark ? TColors.black : TColors.light,
    ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No notifications found'.tr));
          }

          var notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notification = notifications[index].data() as Map<String, dynamic>;

              String title = notification['title'] ?? 'No Title';
              String body = notification['body'] ?? 'No Body';
              String docId = notifications[index].id;
              String imageUrl = notification['imageUrl'] ?? '';
              String targetScreen = notification['targetScreen'] ?? '';
              bool isRead = notification['isRead'] ?? false;
              Timestamp? timestamp = parseTimestamp(notification['timestamp']);
              String formattedTimestamp = timestamp != null
                  ? formatTimestamp(timestamp)
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
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
