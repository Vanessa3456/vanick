import 'package:flutter/material.dart';

class GoogleSignin extends StatefulWidget {
  const GoogleSignin({super.key});

  @override
  State<GoogleSignin> createState() => _GoogleSigninState();
}

class _GoogleSigninState extends State<GoogleSignin> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Google signin'),
      ),
    );
  }
}