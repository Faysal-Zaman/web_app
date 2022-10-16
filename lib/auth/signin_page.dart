import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_app/auth/auth.dart';

import 'signup_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

// form key...
final formKey = GlobalKey<FormState>();

class _SignInPageState extends State<SignInPage> {
  // auth reference
  var auth = Auth();

  @override
  Widget build(BuildContext context) {
    // editing controller...
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passController = TextEditingController();

    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset("assets/logo.png")),
                const SizedBox(height: 20),
                Container(
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
                      hintText: "Eamil",
                      prefixIcon: const Icon(Icons.mail),
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
                    controller: passController,
                    keyboardType: TextInputType.visiblePassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => value != null && value.length < 6
                        ? 'Enter min. 6 characters'
                        : null,
                    onSaved: (value) {
                      passController.text = value!;
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
                const SizedBox(height: 30),
                SizedBox(
                  width: 300,
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(50),
                    child: MaterialButton(
                      onPressed: () async {
                        auth.handleSignInEmail(emailController.text.trim(),
                            passController.text.trim(), context);
                      },
                      color: Colors.amber,
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                      minWidth: double.infinity,
                      child: const Text(
                        "Login",
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
                    const Text("Don't have an account?  "),
                    GestureDetector(
                      child: const Text(
                        "Sign Up",
                        style:
                            TextStyle(color: Colors.deepPurple, fontSize: 20),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const SignUpScreen(),
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
      ),
    );
  }
}
