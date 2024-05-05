import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_practice/screens/email%20auth/signup_screen.dart';
import 'package:firebase_practice/screens/phone%20auth/sign_with_phone.dart';
import 'package:firebase_practice/serive/auth_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageCntroller = TextEditingController();
  File? profilePic;

  void saveInfo() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String ageString = ageCntroller.text.trim();
    int age = int.parse(ageString);

    nameController.clear();
    emailController.clear();
    ageCntroller.clear();

    UploadTask uploadTask = FirebaseStorage.instance
        .ref('profilePics')
        .child(const Uuid().v1())
        .putFile(profilePic!);

    TaskSnapshot taskSnapshot = await uploadTask;

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    Map<String, dynamic> userData = {
      'name ': name,
      'email': email,
      'age': age,
      'profilePic': downloadUrl,
    };
    // 'profilePic':<url>};
    await FirebaseFirestore.instance.collection('users').add(userData);
    setState(() {
      profilePic = null;
    });
  }

  void getInitialMessage() async {
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();

    if (message != null) {
      if (message.data["page"] == "email") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SignupScreen()));
      } else if (message.data["page"] == "phone") {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SignWithPhone()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Invalid Page!"),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${message.notification!.body}"),
          backgroundColor: Colors.green,
        ),
      );
      // Handle received message
      log('Received message: ${message.notification?.title}');
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("App was opened by a notification"),
        duration: Duration(seconds: 10),
        backgroundColor: Colors.green,
      ));
    });
  }

  void delete(String docId) async {
    await FirebaseFirestore.instance.collection('users').doc(docId).delete();
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    AuthSerive.logout();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        backgroundColor: Colors.black,
        title: const Text("HomePage"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 14,
            ),
            SizedBox(
              child: ElevatedButton(
                onPressed: () async {
                  XFile? selectedImage = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (selectedImage != null) {
                    File convertedFile = File(selectedImage.path);
                    setState(() {
                      profilePic = convertedFile;
                    });
                  } else {
                    log('no image selected');
                  }
                },
                child: CircleAvatar(
                  backgroundImage:
                      (profilePic != null) ? FileImage(profilePic!) : null,
                  radius: 75,
                  backgroundColor: Colors.blue,
                ),
              ),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Enter a Name'),
            ),
            const SizedBox(
              height: 14,
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Enter a Email'),
            ),
            const SizedBox(
              height: 14,
            ),
            TextField(
              controller: ageCntroller,
              decoration: const InputDecoration(labelText: 'Enter a age'),
            ),
            const SizedBox(
              height: 14,
            ),
            TextButton(
              onPressed: () {
                saveInfo();
              },
              child: const Text('Save'),
            ),
            const SizedBox(
              height: 14,
            ),
            Expanded(
              child: StreamBuilder(
                  //for filtering data
                  // stream: FirebaseFirestore.instance
                  //     .collection('users')
                  //     .where('age', isGreaterThanOrEqualTo: 18)
                  //     .snapshots(),

                  //orderd by -for making ordered data
                  // stream: FirebaseFirestore.instance
                  //     .collection('users')
                  //     .orderBy(
                  //       'age',
                  //     )
                  //     .snapshots(),

                  //ordered and filtered
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            Map<String, dynamic> userMap =
                                snapshot.data?.docs[index].data()
                                    as Map<String, dynamic>;
                            String docId = snapshot.data!.docs[index].id;
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(userMap['profilePic']),
                              ),
                              title: Text(
                                  userMap["name "] + ' (${userMap['age']})'),
                              subtitle: Text(userMap["email"]),
                              trailing: IconButton(
                                  onPressed: () {
                                    delete(docId);
                                  },
                                  icon: const Icon(Icons.delete)),
                            );
                          },
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }
                    return const Text('data');
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
