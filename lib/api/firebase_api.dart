import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

final navigatorKey = GlobalKey<NavigatorState>();
final logger = Logger();

@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  logger.d('Background Message: ${message.notification?.title}');
  logger.d('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _analytics = FirebaseAnalytics.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final _firestore = FirebaseFirestore.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.high,
  );

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState?.pushNamed(
      '/notification-page',
      arguments: message.data,
    );
  }

  Future<void> initNotifications() async {
    try {
      await _firebaseMessaging.requestPermission();
      final fcmToken = await _firebaseMessaging.getToken();
      logger.d('FCM Token: $fcmToken');

      await _analytics.logEvent(
        name: 'fcm_token_generated',
        parameters: {'token': fcmToken ?? ''},
      );

      await initLocalNotifications();
      await initPushNotifications();
    } catch (e) {
      logger.e('Error initializing notifications: $e');
    }
  }

  Future<void> initLocalNotifications() async {
    // Changed to use @mipmap/ic_launcher instead of notification_icon
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) async {
        final payload = response.payload;
        if (payload != null) {
          final data = jsonDecode(payload);
          navigatorKey.currentState?.pushNamed(
            '/notification-page',
            arguments: data,
          );
        }
      },
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> initPushNotifications() async {
    try {
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

      FirebaseMessaging.onMessage.listen((message) async {
        final notification = message.notification;
        final imageUrl = message.data['image'];

        if (notification != null) {
          await _saveNotificationToFirebase(notification.title, notification.body, message.data, imageUrl);

          NotificationDetails notificationDetails;
          var vibrationPattern = Int64List.fromList([0, 1000, 500, 1000]);

          if (imageUrl != null && imageUrl.isNotEmpty) {
            final bigPictureStyleInformation = BigPictureStyleInformation(
              ByteArrayAndroidBitmap(await _downloadAndConvertToBytes(imageUrl)),
              largeIcon: ByteArrayAndroidBitmap(await _downloadAndConvertToBytes(imageUrl)),
              contentTitle: notification.title,
              summaryText: notification.body,
            );

            notificationDetails = NotificationDetails(
              android: AndroidNotificationDetails(
                _androidChannel.id,
                _androidChannel.name,
                channelDescription: _androidChannel.description,
                styleInformation: bigPictureStyleInformation,
                icon: '@mipmap/ic_launcher',  // Changed to use app icon
                vibrationPattern: vibrationPattern,
                enableVibration: true,
              ),
            );
          } else {
            notificationDetails = NotificationDetails(
              android: AndroidNotificationDetails(
                _androidChannel.id,
                _androidChannel.name,
                channelDescription: _androidChannel.description,
                icon: '@mipmap/ic_launcher',  // Changed to use app icon
                vibrationPattern: vibrationPattern,
                enableVibration: true,
              ),
            );
          }

          await _localNotifications.show(
            notification.hashCode,
            notification.title,
            notification.body,
            notificationDetails,
            payload: jsonEncode(message.data),
          );
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    } catch (e) {
      logger.e('Error in initPushNotifications: $e');
    }
  }

  Future<Uint8List> _downloadAndConvertToBytes(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      logger.d("Failed to load image, status code: ${response.statusCode}");
      return Uint8List(0);
    } catch (e) {
      logger.d("Error loading image: $e");
      return Uint8List(0);
    }
  }

  Future<void> _saveNotificationToFirebase(
      String? title, String? body, Map<String, dynamic> data, [String? imageUrl]) async {
    try {
      await _firestore.collection('Notifications').add({
        'title': title,
        'body': body,
        'data': data,
        'image': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      logger.d("Error saving notification to Firebase: $e");
    }
  }
}