import 'package:firebase_auth/firebase_auth.dart';
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
      print('please fill the details');
    } else if (password != cPassword) {
      print("passwords not matching");
    } else {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User created successfully'),
          backgroundColor: Colors.green,
        ));
        if (userCredential.user != null) {
          Navigator.pop(context);
        }
      } on FirebaseAuthException catch (e) {
        print(e.toString());
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
            TextButton(
              onPressed: () {
                createAccount();
              },
              style:
                  ButtonStyle(iconColor: WidgetStateProperty.all(Colors.blue)),
              child: const Text('Create a account'),
            ),
          ],
        ),
      ),
    );
  }
}
