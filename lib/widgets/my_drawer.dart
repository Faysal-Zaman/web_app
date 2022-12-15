import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../auth/auth.dart';
import '../global/colors.dart';

class MyDrawerWidget extends StatefulWidget {
  const MyDrawerWidget({super.key});

  @override
  State<MyDrawerWidget> createState() => _MyDrawerWidgetState();
}

class _MyDrawerWidgetState extends State<MyDrawerWidget> {
  Auth auth = Auth();
  final userInfo = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      elevation: 10,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue[900],
            ),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue[900],
                  radius: 50,
                  backgroundImage: const AssetImage('assets/logo.png'),
                ),
                const SizedBox(
                  height: 10,
                ),
                FittedBox(
                  child: Text(
                    userInfo.email.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ],
            ),
          ),
          // button for leave application page
          const SizedBox(height: 20),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text(
                    "If you want to leave today,\nclick on the button below 👇"),
              ),
              ListTile(
                title: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    gradient: const LinearGradient(
                      colors: [
                        MyColors.peach,
                        Color.fromARGB(237, 192, 167, 254),
                        MyColors.peach,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(5),
                  child: TextButton.icon(
                    onPressed: () {
                      // show dialog box
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Leave Application"),
                            content: const Text(
                                "Are you sure you want to leave today?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("No"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  addLeaveToTheFirebase();
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Yes"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    style: TextButton.styleFrom(elevation: 10),
                    icon: const Icon(
                      Icons.emergency,
                      size: 30,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Leave",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> addLeaveToTheFirebase() async {
    final setAttendence = FirebaseFirestore.instance
        .collection("Attendence")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection(DateFormat.MMM().format(DateTime.now()).toString())
        .doc(DateFormat.d().format(DateTime.now()).toString());

    final user = {
      'email': userInfo.email.toString(),
      'date': DateFormat.yMMMd().format(DateTime.now()).toString(),
      'user_id': userInfo.uid.toString(),
      'attendence_inTime': "Leave",
      'attendence_outTime': "Leave",
    };

    setAttendence.set(user);
  }
}
