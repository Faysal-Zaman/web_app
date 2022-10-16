import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AttendenceList extends StatelessWidget {
  const AttendenceList({
    Key? key,
    required this.divider,
  }) : super(key: key);

  final Widget divider;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.email.toString())
        .doc("Attendence")
        .collection(DateFormat.MMM().format(DateTime.now()).toString())
        .orderBy('attendence_inTime', descending: true)
        .snapshots();

    return StreamBuilder(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(body: Text("something went wrong"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Text("Loading"));
        }

        if (!snapshot.hasData) {
          return const Scaffold(body: Text("There is no data"));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(1),
              height: 40,
              color:
                  Colors.primaries[Random().nextInt(Colors.primaries.length)],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(snapshot.data!.docs[index]['email']),
                  Text(snapshot.data!.docs[index]['date']),
                  Text(snapshot.data!.docs[index]['attendence_inTime']),
                  Text(snapshot.data!.docs[index]['attendence_outTime']),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
