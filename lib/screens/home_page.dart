import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/screens/phone%20auth/sign_with_phone.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  void saveInfo() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();

    nameController.clear();
    emailController.clear();

    Map<String, dynamic> UserData = {'name ': name, 'email': email};
    await FirebaseFirestore.instance.collection('users').add(UserData);
  }

  void delete(String docId) async {
    await FirebaseFirestore.instance.collection('users').doc(docId).delete();
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.popUntil(context, (route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignWithPhone()),
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
        backgroundColor: Colors.blue,
        title: const Text("HomePage"),
      ),
      body: Column(
        children: [
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
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
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
                            leading: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.update)),
                            title: Text(userMap["name "]),
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
    );
  }
}
