import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_practice/screens/home_page.dart';
import 'package:firebase_practice/screens/phone%20auth/sign_with_phone.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc('N8LUEsg8oAaHRkTRRj74')
      .get();
  log(snapshot.data().toString());
  // log(snapshot.docs.toString());
  // for (var doc in snapshot.docs) {
  //   log(doc.data().toString());
  // }
  log('users fetcehd  successfully');

  Map<String, dynamic> userdata = {
    'name': "coderg",
    'email': 'email111@gmail.com'
  };

  await FirebaseFirestore.instance
      .collection('users')
      .doc('userInfo')
      .set(userdata);
  log("user added successfully");

  await FirebaseFirestore.instance.collection('users').doc('userInfo').delete();
  log("user updated successfully");

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
          : const SignWithPhone(),
    );
  }
}
