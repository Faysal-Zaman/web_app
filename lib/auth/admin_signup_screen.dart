import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:web_app/auth/auth.dart';
import 'package:web_app/auth/signin_page.dart';
import 'package:web_app/global/colors.dart';

class AdminSignUpScreen extends StatefulWidget {
  const AdminSignUpScreen({super.key});

  @override
  State<AdminSignUpScreen> createState() => _AdminSignUpScreenState();
}

class _AdminSignUpScreenState extends State<AdminSignUpScreen> {
  bool visibility = true;
  var authHandler = Auth();

// editing controller...
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 1,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.2,
                child: Image.asset("assets/logo.png"),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              const Text(
                "Admin Sign Up",
                style: TextStyle(
                  color: MyColors.peach,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextFormField(
                        autofocus: false,
                        controller: nameController,
                        keyboardType: TextInputType.visiblePassword,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.length < 3
                            ? 'Enter min. 3 characters'
                            : null,
                        onSaved: (value) {
                          nameController.text = value!;
                        },
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: "Name",
                          prefixIcon: const Icon(Icons.perm_identity,
                              color: Colors.black),
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.1,
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
                          prefixIcon:
                              const Icon(Icons.email, color: Colors.black),
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.1,
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
                        obscureText: visibility == true ? true : false,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon:
                              const Icon(Icons.key, color: Colors.black),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                visibility = !visibility;
                              });
                            },
                            icon: Icon(
                              visibility == true
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            ),
                          ),
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(80),
                  gradient: const LinearGradient(
                    colors: [
                      MyColors.peach,
                      Color.fromARGB(237, 192, 167, 254),
                      MyColors.peach,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.1,
                child: TextButton(
                  onPressed: () async {
                    authHandler.handleSignUp(emailController.text.trim(),
                        passwordController.text.trim(), context);
                  },
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?   "),
                  GestureDetector(
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: MyColors.peach,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
