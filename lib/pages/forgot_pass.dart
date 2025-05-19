import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vanick/components.dart';
import 'package:vanick/routes.dart';

class ForgotPass extends StatefulWidget {
  const ForgotPass({super.key});

  @override
  State<ForgotPass> createState() => _ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass> {
  final emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      showToast(message: "Check your email for the password reset link");
    } on FirebaseAuthException catch (e) {
      showToast(message: e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade300,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              height: deviceHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Space(
                  //   containerHeight: deviceHeight * 0.08,
                  // ),
                  Text(
                    'Enter your email for the password reset link',
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Space(containerHeight: deviceHeight * 0.03),
                  TextForm(
                    containerWidth: deviceWidth / 1.2,
                    hintText: "Email",
                    controller: emailController,
                    obsecure: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  Space(containerHeight: deviceHeight * 0.03),
                  MyButton(
                    text: 'Reset password',
                    onTap: () {
                      passwordReset();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
