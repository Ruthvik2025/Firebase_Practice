import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_practice/firebase_options.dart';
import 'package:firebase_practice/screens/email%20auth/signup_screen.dart';
import 'package:firebase_practice/screens/home_page.dart';
import 'package:firebase_practice/serive/firebase_msgnotification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.intialize();

  AndroidInitializationSettings androidInitializationSettings =
      const AndroidInitializationSettings("@mipmap/ic_launcher");

  DarwinInitializationSettings darwinInitializationSettings =
      const DarwinInitializationSettings(
          requestAlertPermission: true,
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestCriticalPermission: true);

  InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings);

  bool? initialized = await notificationsPlugin.initialize(
    initializationSettings,
  );
  log("intialized:$initialized");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "firebase",
      home: (FirebaseAuth.instance.currentUser != null)
          ? const HomePage()
          : const SignupScreen(),
      theme: ThemeData.light(),
    );
  }
}
