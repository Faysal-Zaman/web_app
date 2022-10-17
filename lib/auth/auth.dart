import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_app/main.dart';

import 'signin_page.dart';

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // SIGN UP METHOD
  Future handleSignUp(
      String email, String password, BuildContext context) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    print("signup");
  }

// SIGN IN MEHTOD
  Future handleSignInEmail(
      String email, String password, BuildContext context) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    print("singin");
  }

  //SIGN OUT METHOD
  Future signOut() async {
    try {
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    print('signout');
  }
}
