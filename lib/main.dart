import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/user_panel.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// We're using the manual installation on non-web platforms
  /// since Google sign in plugin doesn't yet support Dart initialization.
  /// See related issue: https://github.com/flutter/flutter/issues/96391
  if (!kIsWeb) {
    await Firebase.initializeApp();
  } else {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDxZFhaWVnERG35jjjJbEORrFq_614liPI",
          authDomain: "food-app-1efe2.firebaseapp.com",
          projectId: "food-app-1efe2",
          storageBucket: "food-app-1efe2.appspot.com",
          messagingSenderId: "373285333576",
          appId: "1:373285333576:web:00fe96651ddede812ac67d"),
    );
  }

  runApp(
    const MyApp(),
  );
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return const Scaffold(
                body: Center(child: Text("Something has wrong")));
          } else if (snapshot.hasData) {
            return const UserPanelScreen();
          } else {
            return const HomePage();
          }
        },
      ),
    );
  }
}
