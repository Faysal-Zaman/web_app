import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ntp/ntp.dart';

import '../auth/auth.dart';

class UserPanelScreen extends StatefulWidget {
  const UserPanelScreen({super.key});

  @override
  State<UserPanelScreen> createState() => _UserPanelScreenState();
}

class _UserPanelScreenState extends State<UserPanelScreen> {
  String attendenceInTime = "";
  String attendenceOutTime = "";
  String taskStaringTime = '';
  String taskEndingTime = '';
  String dropDownValue = '';
  String todaysDate = '';
  bool cond = true;
  bool attSubmit = false;
  bool taskSubmit = false;

  String? _selectedLocation;

  final List<String> _locations = [
    'is Completed',
    'in Progress',
  ];

  // initialize a index
  int _selectedIndex = 0;

  // Reference of Auth...
  var auth = Auth();

  final userInfo = FirebaseAuth.instance.currentUser!;

  DateTime now = DateTime.now();
  DateTime ntpTime = DateTime.now();
  @override
  void initState() {
    super.initState();
    _loadNTPTime();
  }

  void _loadNTPTime() async {
    setState(() async {
      ntpTime = await NTP.now();
    });
  }

  Future getInTime() async {
    setState(() {
      attendenceInTime = DateFormat.jm().format(ntpTime).toString();
    });
  }

  Future getStartTime() async {
    setState(() {
      taskStaringTime = DateFormat.jm().format(ntpTime).toString();
    });
  }

  Future getOutTime() async {
    setState(() {
      attendenceOutTime = DateFormat.jm().format(ntpTime).toString();
    });
  }

  Future getEndTime() async {
    setState(() {
      taskEndingTime = DateFormat.jm().format(ntpTime).toString();
    });
  }

  Future getDate() async {
    setState(
      () {
        todaysDate = DateFormat.yMMMd().format(DateTime.now()).toString();
      },
    );
  }

  //DateFormat.yMMMd().format(DateTime.now()).toString()

  Future<void> addInTimeToFireStore() async {
    final setAttendence = FirebaseFirestore.instance
        .collection("Attendence")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection(DateFormat.MMM().format(DateTime.now()).toString())
        .doc(DateFormat.d().format(DateTime.now()).toString());

    final user = {
      'email': userInfo.email.toString(),
      'date': DateFormat.yMMMd().format(DateTime.now()).toString(),
      'user_id': userInfo.uid.toString(),
      'attendence_inTime': attendenceInTime,
      'attendence_outTime': attendenceOutTime,
    };

    setAttendence.set(user);
  }

  Future<void> addOutTimeToFireStore() async {
    final setAttendence = FirebaseFirestore.instance
        .collection("Attendence")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection(DateFormat.MMM().format(DateTime.now()).toString())
        .doc(DateFormat.d().format(DateTime.now()).toString());

    final user = {
      'attendence_outTime': attendenceOutTime,
    };

    setAttendence.update(user);
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
      'task_progress': dropDownValue,
      'task_startTime': taskStaringTime,
      'task_endTime': taskEndingTime,
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
      'task_endTime': taskEndingTime,
      'task_progress': dropDownValue,
    };

    setAttendence.update(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: _selectedIndex == 0
            ? const Text(
                "Attendence System",
                style: TextStyle(
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              )
            : const Text(
                "Task Management System",
                style: TextStyle(
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
        centerTitle: true,
        elevation: 0,
        leading: SizedBox(
          width: 100,
          height: 100,
          child: CircleAvatar(
            child: Image.asset(
              'assets/logo.png',
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue,
            strokeAlign: StrokeAlign.inside,
            width: 10,
          ),
        ),
        child: Row(
          children: <Widget>[
            // create a navigation rail
            NavigationRail(
              elevation: 1,
              leading: Container(
                height: 50,
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(5),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    auth.signOut();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    // side: BorderSide(color: Colors.yellow, width: 5),
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontStyle: FontStyle.normal),
                    shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  icon: const Icon(
                    Icons.logout,
                    size: 30,
                  ),
                  label: const Text("Logout"),
                ),
              ),
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.selected,
              backgroundColor: Colors.blue,
              destinations: const <NavigationRailDestination>[
                // navigation destinations
                NavigationRailDestination(
                  icon: Icon(
                    Icons.person_outline,
                    size: 50,
                  ),
                  selectedIcon: Icon(
                    Icons.person_rounded,
                    size: 50,
                  ),
                  label: Text(
                    'Attendence',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
                NavigationRailDestination(
                  icon: Icon(
                    Icons.task_outlined,
                    size: 50,
                  ),
                  selectedIcon: Icon(
                    Icons.task_rounded,
                    size: 50,
                  ),
                  label: Text(
                    'Task',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ),
              ],
              selectedIconTheme: const IconThemeData(color: Colors.white),
              unselectedIconTheme: const IconThemeData(color: Colors.black),
              selectedLabelTextStyle: const TextStyle(color: Colors.white),
            ),

            _selectedIndex == 0
                ? Container(
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
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    //Attendence in Time
                                    SizedBox(
                                      width: 200,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          getInTime();
                                          setState(() {
                                            attSubmit = false;
                                            attendenceOutTime = "";
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          // side: BorderSide(color: Colors.yellow, width: 5),
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontStyle: FontStyle.normal),
                                          shape: const BeveledRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        child: Text(
                                          attendenceInTime == ''
                                              ? "Pick in Time   "
                                              : attendenceInTime,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    //Attendence out Time
                                    SizedBox(
                                      width: 200,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          getOutTime();
                                          setState(() {
                                            attSubmit = true;
                                            attendenceInTime = "";
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          // side: BorderSide(color: Colors.yellow, width: 5),
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontStyle: FontStyle.normal),
                                          shape: const BeveledRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        child: Text(
                                          attendenceOutTime == ''
                                              ? "Pick out Time"
                                              : attendenceOutTime,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //submit button
                              attSubmit == false
                                  ? Container(
                                      width: 400,
                                      height: 50,
                                      margin: const EdgeInsets.only(top: 10),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          addInTimeToFireStore();
                                          setState(() {
                                            attendenceInTime = '';
                                            attendenceOutTime = '';
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          // side: BorderSide(color: Colors.yellow, width: 5),
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontStyle: FontStyle.normal),
                                          shape: const BeveledRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        child: const Text(
                                          "Submit In-Time",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 400,
                                      height: 50,
                                      margin: const EdgeInsets.only(top: 10),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          addOutTimeToFireStore();
                                          setState(() {
                                            attendenceInTime = '';
                                            attendenceOutTime = '';
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          // side: BorderSide(color: Colors.yellow, width: 5),
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontStyle: FontStyle.normal),
                                          shape: const BeveledRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                        child: const Text(
                                          "Submit Out-Time",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),

                        ///////////////////////////
                        ///                     ///
                        ///  List of Attendence ///
                        ///                     ///
                        ///////////////////////////

                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: const <Widget>[
                                    Text(
                                      "Email",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Date",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "In Time",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Out Time",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.50,
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  border: Border.all(),
                                ),
                                child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("Attendence")
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.email)
                                      .collection(DateFormat.MMM()
                                          .format(DateTime.now())
                                          .toString())
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return const Center(
                                          child: Text("Something went wrong"));
                                    }

                                    if (!snapshot.hasData) {
                                      return const Center(
                                          child:
                                              Text("Document does not exist"));
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }

                                    return ListView.builder(
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        if (snapshot.hasData) {
                                          return Container(
                                            padding: const EdgeInsets.all(8),
                                            margin: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              border: Border.all(),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  snapshot.data!.docs[index]
                                                      ['email'],
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  snapshot.data!.docs[index]
                                                      ['date'],
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  snapshot.data!.docs[index]
                                                      ['attendence_inTime'],
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  snapshot.data!.docs[index]
                                                      ['attendence_outTime'],
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(
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
                              // Task Starting Time...
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        width: 200,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            getStartTime();
                                            setState(() {
                                              taskEndingTime = "";
                                              taskSubmit = false;
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            // side: BorderSide(color: Colors.yellow, width: 5),
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 25,
                                                fontStyle: FontStyle.normal),
                                            shape: const BeveledRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                          ),
                                          child: taskStaringTime == ''
                                              ? const Text(
                                                  "Pick Start Time",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : Text(
                                                  taskStaringTime,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        height: 50,
                                        width: 200,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            getEndTime();
                                            setState(
                                              () {
                                                taskStaringTime = '';
                                                taskSubmit = true;
                                              },
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            // side: BorderSide(color: Colors.yellow, width: 5),
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 25,
                                                fontStyle: FontStyle.normal),
                                            shape: const BeveledRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                          ),
                                          child: taskEndingTime == ""
                                              ? const Text(
                                                  "Pick End Time",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : Text(
                                                  taskEndingTime,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 50),
                                  DropdownButton(
                                    focusColor: Colors.blue[100],
                                    hint: dropDownValue.isEmpty
                                        ? const Text("Task Status")
                                        : Text(dropDownValue),
                                    items: _locations.map((String val) {
                                      return DropdownMenuItem<String>(
                                        value: val,
                                        child: Text(val),
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
                                  //submit button
                                  const SizedBox(width: 50),
                                  taskSubmit == false
                                      ? Container(
                                          width: 220,
                                          height: 50,
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                addTaskToFireStore();
                                                taskSubmit = true;
                                                taskStaringTime = '';
                                                taskEndingTime = '';
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                              // side: BorderSide(color: Colors.yellow, width: 5),
                                              textStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25,
                                                  fontStyle: FontStyle.normal),
                                              shape:
                                                  const BeveledRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                            ),
                                            child: const Text(
                                              "Submit Start Time",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          width: 220,
                                          height: 50,
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {
                                                updateTaskToFireStore();
                                                taskSubmit = false;
                                                taskStaringTime = '';
                                                taskEndingTime = '';
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue,
                                              // side: BorderSide(color: Colors.yellow, width: 5),
                                              textStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25,
                                                  fontStyle: FontStyle.normal),
                                              shape:
                                                  const BeveledRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                            ),
                                            child: const Text(
                                              "Submit End Time",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
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

                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: const <Widget>[
                                    Text(
                                      "Email",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Date",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Task-Name",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Start Time",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "End Time",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Progress",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.50,
                                padding: const EdgeInsets.all(5),
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  border: Border.all(),
                                ),
                                child: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection("Task")
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.email)
                                      .collection(DateFormat.MMM()
                                          .format(DateTime.now())
                                          .toString())
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return const Center(
                                          child: Text("Something went wrong"));
                                    }

                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }

                                    return ListView.builder(
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        if (snapshot.hasData) {
                                          return Container(
                                            padding: const EdgeInsets.all(8),
                                            margin: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.blue[400],
                                              border: Border.all(),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  snapshot.data!.docs[index]
                                                      ['email'],
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  snapshot.data!.docs[index]
                                                      ['date'],
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  snapshot.data!.docs[index]
                                                      ['task_name'],
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  snapshot.data!.docs[index]
                                                      ['task_startTime'],
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  snapshot.data!.docs[index]
                                                      ['task_endTime'],
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  snapshot.data!.docs[index]
                                                      ['task_progress'],
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
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
