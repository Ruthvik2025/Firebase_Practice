import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> backgroundMessageHandler(RemoteMessage message) async {}

class NotificationService {
  static Future<void> intialize() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        log(token);
      }
      FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);

      log("Notification authorized");
    }
  }
}
