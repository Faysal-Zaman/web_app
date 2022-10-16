import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskList extends StatelessWidget {
  const TaskList({
    Key? key,
    required this.divider,
  }) : super(key: key);

  final Widget divider;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser!.email.toString())
        .doc("Task")
        .collection(DateFormat.MMM().format(DateTime.now()).toString())
        .orderBy('task_startTime', descending: true)
        .snapshots();
    return StreamBuilder(
      stream: _usersStream,
      builder: (context, snapshot) {
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
          shrinkWrap: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(1),
              height: 40,
              color:
                  Colors.primaries[Random().nextInt(Colors.primaries.length)],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(snapshot.data!.docs[index]['email']),
                  Text(snapshot.data!.docs[index]['date']),
                  Text(snapshot.data!.docs[index]['task_name']),
                  Text(snapshot.data!.docs[index]['task_startTime']),
                  Text(snapshot.data!.docs[index]['task_endTime']),
                  Text(snapshot.data!.docs[index]['task_progress']),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
