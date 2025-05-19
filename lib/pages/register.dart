import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vanick/components.dart';
import 'package:vanick/pages/firebase_auth_service.dart';
import 'package:vanick/routes.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final nameController = TextEditingController();
  final passController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNoController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    passController.dispose();
    emailController.dispose();
    phoneNoController.dispose();
    super.dispose();
  }

  void _signUp() async {
    setState(() {
      isLoading = true;
    });

    String email = emailController.text.trim();
    String password = passController.text.trim();

    try {
      User? user = await _auth.signupWithEmailAndPassword(email, password);
      if (email.isEmpty || password.isEmpty) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Please fill in both email and password')),
        // );
        showToast(message: "Fill in the required fields");
      } else if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User successfully created.')),
        );
        Navigator.pushNamed(context, Routes.login);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error ')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

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
                  hintText: "Password",
                  controller: passController,
                  obsecure: true,
                ),
                Space(containerHeight: deviceHeight * 0.03),
                isLoading
                    ? CircularProgressIndicator()
                    : MyButton(
                        text: 'Sign up',
                        onTap: () {
                          _signUp();
                        },
                      ),
                Space(containerHeight: deviceHeight * 0.03),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(thickness: 0.5, color: Colors.grey),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Expanded(
                        child: Divider(thickness: 0.5, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Space(containerHeight: deviceHeight * 0.03),
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
                      const SizedBox(width: 10),
                      Text('Continue with Google'),
                    ],
                  ),
                ),
                Space(containerHeight: deviceHeight * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ',
                        style: TextStyle(fontSize: 16)),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.login);
                      },
                      child: Text(
                        'Log  in',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
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



// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:vanick/components.dart';
// import 'package:vanick/pages/firebase_auth_service.dart';
// import 'package:vanick/routes.dart';

// class Register extends StatefulWidget {
//   const Register({super.key});

//   @override
//   State<Register> createState() => _RegisterState();
// }

// class _RegisterState extends State<Register> {

//   @over
//   @override
//   Widget build(BuildContext context) {
//     double deviceWidth = MediaQuery.of(context).size.width;
//     double deviceHeight = MediaQuery.of(context).size.height;

//     final FirebaseAuthService _auth = FirebaseAuthService();
//     final nameController = TextEditingController();
//     final passController = TextEditingController();
//     final emailController = TextEditingController();
//     final phoneNoController = TextEditingController();

//     @override
//     void dispose() {
//       nameController.dispose();
//       passController.dispose();
//       emailController.dispose();
//       phoneNoController.dispose();
//       super.dispose();
//     }

//     void _signUp() async {
//       String name = nameController.text;
//       String email = emailController.text;
//       String password = passController.text;
//       String phoneNumber = phoneNoController.text;

//       User? user = await _auth.signupWithEmailAndPassword(email, password);
//       if (user != null) {
//         print("User is succesfully created");
//         Navigator.pushNamed(context, Routes.login);
//       } else {
//         print("Error");
//       }
//     }

//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 50),
//                 Icon(
//                   Icons.lock,
//                   size: deviceWidth * 0.2,
//                 ),
//                 Space(containerHeight: deviceHeight * 0.03),
//                 Text(
//                   'Sign up',
//                   style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
//                 ),
//                 Space(containerHeight: deviceHeight * 0.03),
//                 TextForm(
//                   containerWidth: deviceWidth / 1.2,
//                   hintText: "Enter your name",
//                   controller: nameController,
//                   obsecure: false,
//                 ),
//                 Space(containerHeight: deviceHeight * 0.03),
//                 TextForm(
//                   containerWidth: deviceWidth / 1.2,
//                   hintText: "Email",
//                   controller: emailController,
//                   obsecure: false,
//                   keyboardType: TextInputType.emailAddress,
//                 ),
//                 Space(containerHeight: deviceHeight * 0.03),
//                 TextForm(
//                   containerWidth: deviceWidth / 1.2,
//                   hintText: "Phone number",
//                   controller: phoneNoController,
//                   obsecure: false,
//                   keyboardType: TextInputType.phone,
//                 ),
//                 Space(containerHeight: deviceHeight * 0.03),
//                 TextForm(
//                   containerWidth: deviceWidth / 1.2,
//                   hintText: "Password",
//                   controller: passController,
//                   obsecure: true,
//                 ),
//                 Space(
//                   containerHeight: deviceHeight * 0.03,
//                 ),
//                 MyButton(
//                   text: 'Sign up',
//                   onTap: _signUp
//                 ),
//                 Space(
//                   containerHeight: deviceHeight * 0.03,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                           child: Divider(
//                         thickness: 0.5,
//                         color: Colors.grey,
//                       )),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                         child: Text(
//                           'Or',
//                           style: TextStyle(fontSize: 15),
//                         ),
//                       ),
//                       Expanded(
//                           child: Divider(
//                         thickness: 0.5,
//                         color: Colors.grey,
//                       )),
//                     ],
//                   ),
//                 ),
//                 Space(
//                   containerHeight: deviceHeight * 0.03,
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     Navigator.pushNamed(context, Routes.googleSignin);
//                   },
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(
//                         'assets/images/googlelogo.png',
//                         height: deviceHeight * 0.06,
//                       ),
//                       Text('continue with google')
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
