import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/user_panel.dart';

import 'package:ntp/ntp.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDxZFhaWVnERG35jjjJbEORrFq_614liPI",
        authDomain: "food-app-1efe2.firebaseapp.com",
        projectId: "food-app-1efe2",
        storageBucket: "food-app-1efe2.appspot.com",
        messagingSenderId: "373285333576",
        appId: "1:373285333576:web:00fe96651ddede812ac67d"),
  );

  print("Hello");

  runApp(
    const MyApp(),
  );
} // main

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Open Sans'),
      ),
      home: Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.none) {
              return const Center(child: Text("No Internet Connection"));
            } else if (snapshot.hasError) {
              return const Center(child: Text("Something has wrong"));
            } else if (snapshot.hasData) {
              return const UserPanelScreen();
            } else {
              return const HomePage();
            }
          },
        ),
      ),
    );
  }
}
