import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_app/main.dart';

import 'signin_page.dart';

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // SIGN UP METHOD
  Future<User> handleSignUp(
      String email, String password, BuildContext context) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return null!;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    navigatorKey.currentState!.popUntil((route) => route.isFirst);

    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final User user = result.user!;
    print('signup');

    return user;
  }

// SIGN IN MEHTOD
  Future<User> handleSignInEmail(
      String email, String password, BuildContext context) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return null!;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    navigatorKey.currentState!.popUntil((route) => route.isFirst);

    UserCredential result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    final User user = result.user!;
    print('signin');

    return user;
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await auth.signOut();
    print('signout');
  }
}
