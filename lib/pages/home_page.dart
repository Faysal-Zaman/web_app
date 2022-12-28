import 'package:flutter/material.dart';
import 'package:web_app/auth/admin_signin_screen.dart';
import 'package:web_app/auth/signin_page.dart';
import 'package:web_app/global/colors.dart';

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
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Image.asset(
                "assets/logo.png",
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FittedBox(
                      child: Text(
                        "Let's  Mark  Attendence !",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width * 0.2,
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
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignInPage(),
                                  ),
                                );
                              },
                              child: const FittedBox(
                                child: Icon(
                                  Icons.dashboard,
                                  color: Colors.white,
                                  size: 150,
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            "User",
                            style: TextStyle(
                              color: MyColors.peach,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height * 0.15,
                            width: MediaQuery.of(context).size.width * 0.2,
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
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AdminSignInScreen(),
                                  ),
                                );
                              },
                              child: const FittedBox(
                                child: Icon(
                                  Icons.admin_panel_settings,
                                  color: Colors.white,
                                  size: 150,
                                ),
                              ),
                            ),
                          ),
                          const Text(
                            "Admin",
                            style: TextStyle(
                              color: MyColors.peach,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
