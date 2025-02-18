import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'api/firebase_api.dart';
import 'app.dart';
import 'data/repositories/authentication/authentication_repository.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  try {
    final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

    await GetStorage.init();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    // Initialize Firebase first
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Initialize authentication repository
    Get.put(AuthenticationRepository());

    // Initialize Firebase API
    final firebaseApi = FirebaseApi();
    await firebaseApi.initNotifications();

    runApp(const App());
  } catch (e) {
    print('Error in main: $e');
    // You might want to show some error UI here
  }
}