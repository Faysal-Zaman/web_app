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

class _TaskSystemState extends State<TaskSystem> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(left: 10),
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 1.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Top Buttons Portion
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Task Starting Date...
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text for Start Time
                        const Text(
                          "Task Start Date :",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        // Months dropdown
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: DropdownButtonFormField<String>(
                            menuMaxHeight:
                                MediaQuery.of(context).size.height * 0.5,
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                              labelText: taskStartMonth == ""
                                  ? "Month"
                                  : taskStartMonth,
                            ),
                            key: taskStartMonthsKey,
                            focusColor: Colors.white,
                            dropdownColor: MyColors.peach,
                            iconEnabledColor: Colors.black,
                            iconDisabledColor: Colors.black,
                            icon: const Icon(Icons.arrow_drop_down),
                            items: monthsList.map((String val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(
                                  val,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(
                                () {
                                  taskStartMonth = val!;
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        // dates drop down
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: DropdownButtonFormField<String>(
                            menuMaxHeight:
                                MediaQuery.of(context).size.height * 0.5,
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                              labelText: startDate == "" ? "Date" : startDate,
                            ),
                            key: taskStartDateKey,
                            focusColor: Colors.white,
                            dropdownColor: MyColors.peach,
                            iconEnabledColor: Colors.black,
                            iconDisabledColor: Colors.black,
                            icon: const Icon(Icons.arrow_drop_down),
                            items: datesDropDownList.map((String val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(
                                  val,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(
                                () {
                                  startDate = val!;
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        // submit button for start date
                        Container(
                          width: MediaQuery.of(context).size.width * 0.12,
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
                              if (taskStartMonth == "" || startDate == "") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Please select a date",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                setState(() {
                                  taskStartDate = "$taskStartMonth $startDate";
                                });
                                addTaskToFireStore();
                                setState(() {
                                  taskStartMonth = "";
                                  startDate = "";
                                });
                              }
                            },
                            style: TextButton.styleFrom(elevation: 10),
                            child: const FittedBox(
                              child: Text(
                                "Submit Start Date",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Task Ending Date...
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // Text for Start Time
                        const Text(
                          "   Task End Date :",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        // Months dropdown
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: DropdownButtonFormField<String>(
                            menuMaxHeight:
                                MediaQuery.of(context).size.height * 0.5,
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                              labelText:
                                  taskEndMonth.isEmpty ? "Month" : taskEndMonth,
                            ),
                            key: taskEndMonthsKey,
                            focusColor: Colors.white,
                            dropdownColor: MyColors.peach,
                            iconEnabledColor: Colors.black,
                            iconDisabledColor: Colors.black,
                            icon: const Icon(Icons.arrow_drop_down),
                            items: monthsList.map((String val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(
                                  val,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(
                                () {
                                  taskEndMonth = val!;
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        // dates drop down
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: DropdownButtonFormField<String>(
                            menuMaxHeight:
                                MediaQuery.of(context).size.height * 0.5,
                            decoration: InputDecoration(
                              labelStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                              labelText: endDate.isEmpty ? "Date" : endDate,
                            ),
                            key: taskEndDateKey,
                            focusColor: Colors.white,
                            dropdownColor: MyColors.peach,
                            iconEnabledColor: Colors.black,
                            iconDisabledColor: Colors.black,
                            icon: const Icon(Icons.arrow_drop_down),
                            items: datesDropDownList.map((String val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(
                                  val,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(
                                () {
                                  endDate = val!;
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        // Submit Button for End Date
                        Container(
                          width: MediaQuery.of(context).size.width * 0.12,
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
                              if (taskEndMonth == "" || endDate == "") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Please select a date",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                setState(() {
                                  taskEndDate = "$taskEndMonth $endDate";
                                });
                                updateTaskToFireStore();
                                setState(() {
                                  taskEndMonth = "";
                                  endDate = "";
                                });
                              }
                            },
                            style: TextButton.styleFrom(elevation: 10),
                            child: const FittedBox(
                              child: Text(
                                "Submit End Date",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

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
                height: MediaQuery.of(context).size.height * 0.65,
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                          color: MyColors.peach,
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: MyColors.peach,
                      ));
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        if (snapshot.hasData) {
                          return Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  MyColors.peach,
                                  Color.fromARGB(236, 146, 103, 253),
                                  MyColors.peach,
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      "Email",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!.docs[index]['email'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      "Task-Name",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!.docs[index]['task_name'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      "Starting Date",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!.docs[index]
                                          ['task_startDate'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      "Ending Date",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!.docs[index]
                                          ['task_endDate'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      "Progress",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!.docs[index]
                                          ['task_progress'],
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Visibility(
                                  visible: snapshot.data!.docs[index]['date'] ==
                                          DateFormat.yMMMd()
                                              .format(DateTime.now())
                                      ? true
                                      : false,
                                  child: Column(
                                    children: [
                                      DropdownButton(
                                        key: sKey,
                                        focusColor: Colors.deepPurple[300],
                                        dropdownColor: Colors.deepPurple[300],
                                        iconEnabledColor: Colors.white,
                                        iconDisabledColor: Colors.white,
                                        hint: dropDownValue.isEmpty
                                            ? const Text(
                                                "Task Status",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            : Text(
                                                dropDownValue,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                        items: dropDownList.map((String val) {
                                          return DropdownMenuItem<String>(
                                            value: val,
                                            child: Text(
                                              val,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          setState(
                                            () {
                                              dropDownValue = val!;
                                            },
                                          );
                                        },
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(80),
                                          gradient: const LinearGradient(
                                            colors: [
                                              MyColors.peach,
                                              Color.fromARGB(
                                                  237, 192, 167, 254),
                                              MyColors.peach,
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            updateProgressToFireStore();
                                          },
                                          style: TextButton.styleFrom(
                                              elevation: 10),
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

  Future<String> getStartDate() async {
    setState(
      () {
        // taskStartDate = date!;
      },
    );
    return taskStartDate;
  }

  Future<String> getEndDate() async {
    setState(
      () {
        // taskEndDate = date!;
      },
    );
    return taskEndDate;
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
      'task_progress': "🤔",
      'task_startDate': taskStartDate,
      'task_endDate': taskEndDate,
    };

    setAttendence.set(user);
  }

  Future<void> updateTaskToFireStore() async {
    final setAttendence = FirebaseFirestore.instance
        .collection("Task")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection(DateFormat.MMM().format(DateTime.now()).toString())
        .doc(DateFormat.d().format(DateTime.now()).toString());

    final user = {
      'task_endDate': taskEndDate,
    };

    setAttendence.update(user);
  }

  Future<void> updateProgressToFireStore() async {
    final setAttendence = FirebaseFirestore.instance
        .collection("Task")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection(DateFormat.MMM().format(DateTime.now()).toString())
        .doc(DateFormat.d().format(DateTime.now()).toString());

    final user = {
      'task_progress': dropDownValue,
    };

    setAttendence.update(user);
  }
}
