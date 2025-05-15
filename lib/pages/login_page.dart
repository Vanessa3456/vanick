// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:vanick/components.dart';
import 'package:vanick/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    final passController = TextEditingController();
    final emailController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Icon(
                  Icons.lock_open,
                  size: deviceWidth * 0.2,
                ),
                Space(containerHeight: deviceHeight * 0.03),
                Text(
                  'Log in',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
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
                TextForm(
                  containerWidth: deviceWidth / 1.2,
                  hintText: "Password",
                  controller: passController,
                  obsecure: true,
                ),
                Space(
                  containerHeight: deviceHeight * 0.03,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          // Navigate to the Forgot Password screen or handle the action
                          print("Forgot password tapped");
                        },
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.blue,

                            decoration: TextDecoration
                                .underline, // Makes it look like a link
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Space(
                  containerHeight: deviceHeight * 0.03,
                ),
                MyButton(
                  text: 'login',
                  onTap: () {
                    print('Nick firebase');
                  },
                ),
                Space(
                  containerHeight: deviceHeight * 0.03,
                ),
                Text(
                  'OR',
                  style: TextStyle(color: Colors.grey),
                ),
                Space(
                  containerHeight: deviceHeight * 0.03,
                ),
                MyButton(
                  text: 'Login with OTP',
                  onTap: () {
                    Navigator.pushNamed(context, Routes.otp);
                  },
                ),
                Space(
                  containerHeight: deviceHeight * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No account?',
                      style: TextStyle(fontSize: 20),
                    ),
                    InkWell(
                      onTap: () {
                        // Navigate to the Forgot Password screen or handle the action
                        Navigator.pushNamed(context, Routes.register);
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue,

                          decoration: TextDecoration
                              .underline, // Makes it look like a link
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
