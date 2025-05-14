import 'package:flutter/material.dart';

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
                    child: Image.asset(
                      'assets/images/vanick3.png',
                      // fit: BoxFit.cover, // Makes the image occupy all space
                    ),
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
                        onPressed: () => (),
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
                          onPressed: () => (),
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
