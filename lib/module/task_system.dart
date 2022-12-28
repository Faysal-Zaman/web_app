import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../auth/auth.dart';
import '../global/colors.dart';
import '../global/my_data.dart';

class TaskSystem extends StatefulWidget {
  const TaskSystem({super.key});

  @override
  State<TaskSystem> createState() => _TaskSystemState();
}

List<DropdownMenuItem<String>> _dropDownItem() {
  List<String> itemValue = [
    'is Completed',
    'in Progress',
  ];

  return itemValue
      .map((value) => DropdownMenuItem(
            value: value,
            child: Text(value.toString()),
          ))
      .toList();
}

class _TaskSystemState extends State<TaskSystem> {
  List<String> selectedItemValue = [];

  String taskStartDate = '';
  String taskEndDate = '';

  String startDate = '';
  String endDate = '';
  String taskMonth = '';

  String taskStartMonth = '';
  String taskEndMonth = '';

  bool taskSubmit = false;
  bool attSubmit = false;

  final sKey = GlobalKey();

  static String dropDownValue = '';

  static final List<String> dropDownList = [
    'is Completed',
    'in Progress',
  ];

  var auth = Auth();
  final userInfo = FirebaseAuth.instance.currentUser!;

  String comment = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 10),
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ///////////////////////////
          ///                     ///
          ///     List of Task    ///
          ///                     ///
          ///////////////////////////

          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const <Widget>[],
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.78,
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: MyColors.peach,
                  border: Border.all(),
                ),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Task")
                      .doc(FirebaseAuth.instance.currentUser!.email)
                      .collection(
                          DateFormat.MMM().format(DateTime.now()).toString())
                      .orderBy("task_startDate", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text("Something went wrong"));
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        for (int i = 0; i < 2; i++) {
                          selectedItemValue.add(dropDownList[i]);
                        }
                        if (snapshot.hasData) {
                          return Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.all(5),
                            color: Colors.white,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text(
                                      "Task Name",
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        snapshot.data!.docs[index]['task_name'],
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.blueGrey,
                                  thickness: 1,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    const Text(
                                      "Comments",
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: snapshot.data!.docs[index]
                                                  ['task_comments'] ==
                                              ""
                                          ? TextButton.icon(
                                              onPressed: () {
                                                // show dialog box to add comment
                                                TextEditingController comment =
                                                    TextEditingController();
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                        "Add Comment",
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      content: TextField(
                                                        controller: comment,
                                                        onChanged: (value) {
                                                          this.comment = value;
                                                        },
                                                        decoration:
                                                            const InputDecoration(
                                                          hintText:
                                                              "Enter Comment",
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              this.comment =
                                                                  comment.text
                                                                      .trim()
                                                                      .toString();
                                                            });
                                                            updateCommentsToFireStore(
                                                                snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                    .id);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                            "Add",
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                            "Cancel",
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.add,
                                                color: Colors.black,
                                                size: 30,
                                              ),
                                              label: const Text(
                                                "Add Comments",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          : Text(
                                              snapshot.data!.docs[index]
                                                  ['task_comments'],
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.blueGrey,
                                  thickness: 1,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    const Text(
                                      "Start Date",
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        snapshot.data!.docs[index]
                                            ['task_startDate'],
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.blueGrey,
                                  thickness: 1,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    const Text(
                                      "End Date",
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        snapshot.data!.docs[index]
                                            ['task_endDate'],
                                        style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.blueGrey,
                                  thickness: 1,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    const Text(
                                      "Progress",
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        snapshot.data!.docs[index]
                                            ['task_progress'],
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.blueGrey,
                                  thickness: 1,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    SizedBox(
                                      // ignore: sort_child_properties_last
                                      child: const Text(
                                        "Change Status",
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: DropdownButton(
                                        hint: selectedItemValue[index] == null
                                            ? const Text(
                                                "Select Status",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            : Text(
                                                selectedItemValue[index],
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                        value: selectedItemValue[index],
                                        items: _dropDownItem(),
                                        onChanged: (value) {
                                          selectedItemValue[index] =
                                              value.toString();
                                          setState(
                                            () {
                                              print('${index} and ${value}');
                                            },
                                          );
                                        },
                                        menuMaxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color.fromARGB(237, 143, 100, 253),
                                            Color.fromARGB(237, 192, 167, 254),
                                            Color.fromARGB(237, 143, 100, 253),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                      ),
                                      child: TextButton(
                                        onPressed: () {
                                          updateProgressToFireStore(
                                              selectedItemValue[index],
                                              snapshot.data!.docs[index].id);
                                        },
                                        style:
                                            TextButton.styleFrom(elevation: 10),
                                        child: const Text(
                                          "Submit",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  color: Colors.blueGrey,
                                  thickness: 1,
                                ),
                              ],
                            ),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(
                            color: MyColors.peach,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> addTaskToFireStore() async {
    final setAttendence = FirebaseFirestore.instance
        .collection("Task")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection(DateFormat.MMM().format(DateTime.now()).toString())
        .doc(DateFormat.d().format(DateTime.now()).toString());

    final user = {
      'email': userInfo.email.toString(),
      'date': DateFormat.yMMMd().format(DateTime.now()).toString(),
      'task_name': "🤔",
      'task_progress': "Pending",
      'task_startDate': "",
      'task_endDate': "",
      'task_comments': "",
    };

    setAttendence.set(user);
  }

  // Future<void> updateTaskToFireStore() async {
  //   final setAttendence = FirebaseFirestore.instance
  //       .collection("Task")
  //       .doc(FirebaseAuth.instance.currentUser!.email)
  //       .collection(DateFormat.MMM().format(DateTime.now()).toString())
  //       .doc(DateFormat.d().format(DateTime.now()).toString());

  //   final user = {
  //     'task_endDate': taskEndDate,
  //   };

  //   setAttendence.update(user);
  // }

  Future<void> updateProgressToFireStore(index, indexOf) async {
    final setAttendence = FirebaseFirestore.instance
        .collection("Task")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection(DateFormat.MMM().format(DateTime.now()).toString())
        .doc("${indexOf}");

    final user = {
      'task_progress': index.toString(),
    };

    setAttendence.update(user);
  }

  Future<void> updateCommentsToFireStore(indexOf) async {
    final setAttendence = FirebaseFirestore.instance
        .collection("Task")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection(DateFormat.MMM().format(DateTime.now()).toString())
        .doc("${indexOf}");

    final user = {
      'task_comments': comment.toString(),
    };

    setAttendence.update(user);
  }
}
