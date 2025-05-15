// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vanick/routes.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(5.0), // Add some margin
                  decoration: BoxDecoration(
                    // color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: LottieBuilder.asset('assets/images/name.json'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 60.0,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Routes.register);
                        },
                        child: Text('Sign up',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(width: 2)),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                        width: double.infinity,
                        height: 60.0,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.login);
                          },
                          child: Text('Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              )),
                          style: OutlinedButton.styleFrom(
                              side: BorderSide(width: 2)),
                        )),
                    SizedBox(
                      height: 20.0,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
