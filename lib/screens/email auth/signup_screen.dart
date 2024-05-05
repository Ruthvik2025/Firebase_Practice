import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/screens/email%20auth/login_screen.dart';
import 'package:firebase_practice/screens/home_page.dart';
import 'package:firebase_practice/serive/auth_service.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController cpasswordcontroller = TextEditingController();

  void createAccount() async {
    String email = emailcontroller.text.trim();
    String password = passwordcontroller.text.trim();
    String cPassword = cpasswordcontroller.text.trim();

    if (email == '' || password == '' || cPassword == '') {
      log('please fill the details');
    } else if (password != cPassword) {
      log("passwords not matching");
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User created successfully'),
          backgroundColor: Colors.green,
        ));
        if (userCredential.user != null) {
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        log(e.toString());
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.code.toString()),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text("Create an account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: emailcontroller,
              decoration: const InputDecoration(labelText: "Email Address"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: passwordcontroller,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: cpasswordcontroller,
              decoration: const InputDecoration(labelText: "Confirm Password"),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    createAccount();
                  },
                  style: ButtonStyle(
                      iconColor: WidgetStateProperty.all(Colors.blue)),
                  child: const Text('Create a account'),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  // style: ButtonStyle(
                  //     iconColor: WidgetStateProperty.all(Colors.blue)),
                  child: const Text('Sign In'),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await AuthSerive.siginWithGoole();

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  },
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.asset("assets/goole.png"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
