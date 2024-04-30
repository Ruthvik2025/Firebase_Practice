import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/screens/phone%20auth/verify_otp.dart';
import 'package:flutter/material.dart';

class SignWithPhone extends StatefulWidget {
  const SignWithPhone({
    super.key,
  });

  @override
  State<SignWithPhone> createState() => _SignWithPhoneState();
}

class _SignWithPhoneState extends State<SignWithPhone> {
  TextEditingController phoneController = TextEditingController();
  void sendOtp() async {
    String phone = '+91${phoneController.text.trim()}';
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      codeSent: (verificationId, forceResendingToken) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOtp(
              verificationid: verificationId,
            ),
          ),
        );
      }, //it sent codes and gives verification id (it verifies)
      verificationCompleted:
          (credential) {}, //it comes when verificatioon completed
      verificationFailed: (error) {
        print(error.code.toString()); //it uses when verification failed
      },
      codeAutoRetrievalTimeout: (verificationId) {},
      timeout: const Duration(seconds: 30),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Sign in With Phone"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              decoration:
                  const InputDecoration(labelText: 'Enter a Phone number'),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 40,
              width: 100,
              child: TextButton(
                onPressed: () {
                  sendOtp();
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue),
                  iconColor: WidgetStateProperty.all(Colors.white),
                ),
                child: const Text(
                  "Sign In",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
