import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_app/auth/signin_page.dart';

import 'auth.dart';
import '../pages/user_panel.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  var authHandler = Auth();

// editing controller...
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Future<void> addToFireStore() async {
    //save data to Firestore...
    FirebaseFirestore.instance
        .collection('Users_Accounts')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
          'full_name': nameController.text.trim().toString(),
          'email': emailController.text.trim().toString(),
          'password': passwordController.text.trim().toString(),
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> addTaskStatusToFireStore() async {
    FirebaseFirestore.instance
        .collection('Task_Status')
        .doc(FirebaseAuth.instance.currentUser!.uid.toString())
        .set({
          'task_name': "???",
          'task_remarks': "???",
        })
        .then((value) => print("Task Status Added"))
        .catchError((error) => print("Failed to add Task status: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 10),
              SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset("assets/logo.png")),
              const SizedBox(height: 30),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        autofocus: false,
                        controller: nameController,
                        keyboardType: TextInputType.visiblePassword,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.length < 3
                            ? 'Enter correct name'
                            : null,
                        onSaved: (value) {
                          nameController.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "Name",
                          prefixIcon: const Icon(Icons.perm_identity),
                          border: OutlineInputBorder(
                            gapPadding: 20,
                            borderSide: const BorderSide(
                              width: 10,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        autofocus: false,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? 'Enter a valid email'
                                : null,
                        onSaved: (value) {
                          emailController.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            gapPadding: 20,
                            borderSide: const BorderSide(
                              width: 10,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        autofocus: false,
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.length < 6
                            ? 'Enter min. 6 characters'
                            : null,
                        onSaved: (value) {
                          passwordController.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: const Icon(Icons.key),
                          border: OutlineInputBorder(
                            gapPadding: 20,
                            borderSide: const BorderSide(
                              width: 10,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 300,
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(50),
                  child: MaterialButton(
                    onPressed: () async {
                      authHandler.handleSignUp(emailController.text.trim(),
                          passwordController.text.trim(), context);
                    },
                    color: Colors.amber,
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                    minWidth: double.infinity,
                    child: const Text(
                      "Sign Up",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Have an account?  "),
                  GestureDetector(
                    child: const Text(
                      "Sign In",
                      style: TextStyle(color: Colors.deepPurple, fontSize: 20),
                    ),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const SignInPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
