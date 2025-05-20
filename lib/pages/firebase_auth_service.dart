import 'package:firebase_auth/firebase_auth.dart';
import 'package:vanick/components.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signupWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      showToast(message: "Account created successfully");
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: "Email already exists. Please log in.");
      } else if (e.code == 'weak-password') {
        showToast(message: "Password is too weak. Use a stronger password.");
      } else if (e.code == 'invalid-email') {
        showToast(message: "Invalid email format.");
      } else {
        showToast(message: "Error:");
      }
    } catch (e) {
      showToast(message: "An unexpected error occurred: $e");
    }
    return null;
  }

  Future<User?> signinWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      showToast(message: "Login successful");
      return credential.user;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast(message: "No user found with this email.");
      } else if (e.code == 'wrong-password') {
        showToast(message: "Incorrect password.");
      } else if (e.code == 'invalid-email') {
        showToast(message: "Invalid email format.");
      } else {
        showToast(message: "Error: ${e.message}");
      }
    } catch (e) {
      showToast(message: "An unexpected error occurred: $e");
    }
    return null;
  }


  bool loggedIn(){
  return _auth.currentUser!=null;
  }


}
