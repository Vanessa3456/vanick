import 'package:flutter/material.dart';
import 'package:vanick/components.dart';
import 'package:vanick/routes.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    final nameController = TextEditingController();
    final passController = TextEditingController();
    final emailController = TextEditingController();
    final phoneNoController = TextEditingController();

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Icon(
                  Icons.lock,
                  size: deviceWidth * 0.2,
                ),
                Space(containerHeight: deviceHeight * 0.03),
                Text(
                  'Sign up',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                Space(containerHeight: deviceHeight * 0.03),
                TextForm(
                  containerWidth: deviceWidth / 1.2,
                  hintText: "Enter your name",
                  controller: nameController,
                  obsecure: false,
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
                  hintText: "Phone number",
                  controller: phoneNoController,
                  obsecure: false,
                  keyboardType: TextInputType.phone,
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
                MyButton(
                  text: 'Sign up',
                  onTap: () {
                    print('Nick firebase');
                  },
                ),
                Space(
                  containerHeight: deviceHeight * 0.03,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Expanded(
                          child: Divider(
                        thickness: 0.5,
                        color: Colors.grey,
                      )),
                    ],
                  ),
                ),
                Space(
                  containerHeight: deviceHeight * 0.03,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.googleSignin);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/googlelogo.png',
                        height: deviceHeight * 0.06,
                      ),
                      Text('continue with google')
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
