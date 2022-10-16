import 'package:flutter/material.dart';
import 'package:web_app/auth/signin_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset(
                  "assets/logo.png",
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Let's  Make  Attendence !",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInPage(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.forward_outlined,
                      size: 100,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
