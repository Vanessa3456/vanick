import 'package:flutter/material.dart';

class OTPLogin extends StatefulWidget {
  const OTPLogin({super.key});

  @override
  State<OTPLogin> createState() => _OTPLoginState();
}

class _OTPLoginState extends State<OTPLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("OTP Login Page"),
      ),
    );
  }
}
