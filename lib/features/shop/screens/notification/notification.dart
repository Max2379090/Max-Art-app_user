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
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isInitialized = false;
  FirebaseApi firebaseApi = FirebaseApi();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _setupFirebaseMessaging();
  }

  Future<void> _initializeNotifications() async {
    try {
      // Create notification channel group
      const AndroidNotificationChannelGroup channelGroup = AndroidNotificationChannelGroup(
        'product_updates_group',
        'Product Updates',
        description: 'Notifications related to product updates and offers',
      );
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannelGroup(channelGroup);

      // Create notification channel
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'product_updates_channel',
        'Product Updates',
        description: 'Channel for product updates notifications',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        groupId: 'product_updates_group',
      );
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      // Initialize settings - CHANGED HERE to use @mipmap/ic_launcher
      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

      await _notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _handleNotificationTap,
      );

      setState(() => _isInitialized = true);
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
      TLoaders.errorSnackBar(
        title: 'Error'.tr,
        message: 'Failed to initialize notifications'.tr,
      );
    }
  }

  void _setupFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen(_handleFirebaseMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> _handleFirebaseMessage(RemoteMessage message) async {
    if (!_isInitialized) return;
    print('Handling Firebase message...');
    final Map<String, dynamic> data = message.data;
    // print notification data
    print('Notification data: $data');
    try {
      final String title = message.notification?.title ?? 'No Title';
      final String body = message.notification?.body ?? 'No Body';
      final String imageUrl = message.data['image_url'] ?? '';
      final String targetScreen = message.data['target_screen'] ?? '';

      // Save to Firestore first
      await _saveNotificationToFirestore(
        title: title,
        body: body,
        imageUrl: imageUrl,
        targetScreen: targetScreen,
      );

      // Then show the notification
      if (imageUrl.isNotEmpty) {
        final String? base64Image = await _downloadAndEncodeImage(imageUrl);
        await _showNotification(title, body, base64Image);
      } else {
        await _showNotification(title, body, null);
      }
    } catch (e) {
      debugPrint('Error handling Firebase message: $e');
    }
  }

  Future<void> _handleNotificationTap(NotificationResponse response) async {
    if (response.payload != null) {
      final Map<String, dynamic> payload = json.decode(response.payload!);
      if (payload['targetScreen'] != null && payload['targetScreen'].isNotEmpty) {
        Get.toNamed(payload['targetScreen']);
      }
    }
  }

  Future<String?> _downloadAndEncodeImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return base64Encode(response.bodyBytes);
      }
      return null;
    } catch (e) {
      debugPrint('Error downloading image: $e');
      return null;
    }
  }

  Future<void> _showNotification(String title, String body, String? base64Image) async {
    try {
      BigPictureStyleInformation? bigPictureStyleInformation;
      if (base64Image != null) {
        bigPictureStyleInformation = BigPictureStyleInformation(
          ByteArrayAndroidBitmap.fromBase64String(base64Image),
          contentTitle: title,
          summaryText: body,
          hideExpandedLargeIcon: true,
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

              return Dismissible(
                key: Key(doc.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => _deleteNotification(doc.id),
                child: Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        _NotificationImage(
                          imageUrl: imageUrl,
                          onTap: targetScreen.isNotEmpty
                              ? () => Get.toNamed(targetScreen)
                              : null,
                        ),
                        if (!isRead)
                          const Positioned(
                            top: 0,
                            right: 0,
                            child: _UnreadIndicator(),
                          ),
                      ],
                    ),
                    title: Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          body,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formattedTimestamp,
                          style: const TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ],
                    ),
                    onTap: () {
                      _markAsRead(doc.id);
                      Get.to(
                            () => NotificationDetailPage(
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
    this.onTap,
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