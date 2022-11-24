import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'dart:convert' as convert;

import '../auth/auth.dart';
import '../global/colors.dart';

class UserPanelScreen extends StatefulWidget {
  const UserPanelScreen({super.key});

  @override
  State<UserPanelScreen> createState() => _UserPanelScreenState();
}

class _UserPanelScreenState extends State<UserPanelScreen> {
  String attendenceInTime = '';
  String attendenceOutTime = '';
  String taskStartDate = '';
  String taskEndDate = '';
  static String dropDownValue = '';
  String todaysDate = '';
  bool taskSubmit = false;
  bool attSubmit = false;
  bool cond = true;
  final sKey = GlobalKey();
  String? _selectedLocation;

  // Reference of Auth...
  var auth = Auth();
  final userInfo = FirebaseAuth.instance.currentUser!;
  final DateTime _time = DateTime.now();
  String? time;
  String? date;

  // initialize an index
  int _selectedIndex = 0;

  static final List<String> _locations = [
    'is Completed',
    'in Progress',
  ];

  /// for getting the actual time via api

  Future<String?> getCurrentTime() async {
    var url = Uri.parse('http://worldtimeapi.org/api/timezone/Asia/Karachi');
    var response = await get(url);
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      var dateNTime = jsonResponse['datetime'];
      print("response.body => " + jsonResponse['utc_offset']);
      var uc_offset = jsonResponse['utc_offset'].toString().substring(1, 3);
      print("response.body => " + uc_offset);

      DateTime dateTime = DateTime.parse(dateNTime);
      dateTime = dateTime.add(Duration(hours: int.parse(uc_offset)));
      print('dateTime  => ' + dateTime.toString());

      print("dateFormat.jm() => " + DateFormat.jm().format(dateTime));
      print("dateFormat.jm() => " + DateFormat.Hm().format(dateTime));

      // date = DateFormat.MMMd().format(dateTime).toString();
      time = DateFormat.jm().format(dateTime).toString();
      return time;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OOPS! There is a connection problem with Time Server"),
        ),
      );
    }
  }

  Future<String?> getCurrentDate() async {
    var url = Uri.parse('http://worldtimeapi.org/api/timezone/Asia/Karachi');
    var response = await get(url);
    var jsonResponse =
        convert.jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      var dateNTime = jsonResponse['datetime'];
      print("response.body => " + jsonResponse['utc_offset']);
      var uc_offset = jsonResponse['utc_offset'].toString().substring(1, 3);
      print("response.body => " + uc_offset);

      DateTime dateTime = DateTime.parse(dateNTime);
      dateTime = dateTime.add(Duration(hours: int.parse(uc_offset)));
      print('dateTime  => ' + dateTime.toString());

      print("dateFormat.jm() => " + DateFormat.jm().format(dateTime));
      print("dateFormat.jm() => " + DateFormat.Hm().format(dateTime));

      date = DateFormat.MMMd().format(dateTime).toString();
      return date;
      // return time = DateFormat.jm().format(dateTime).toString();

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OOPS! There is a connection problem with Time Server"),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentTime();
    getCurrentDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
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
            backgroundColor: Color.fromARGB(255, 13, 71, 161),
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
            color: Color.fromARGB(255, 13, 71, 161),
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
                height: 50,
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(5),
                child: TextButton.icon(
                  onPressed: () async {
                    auth.signOut();
                  },
                  style: TextButton.styleFrom(elevation: 10),
                  icon: const Icon(
                    Icons.logout,
                    size: 30,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.selected,
              backgroundColor: const Color.fromARGB(255, 13, 71, 161),
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
                                    Container(
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
                                      width: 200,
                                      height: 50,
                                      child: TextButton(
                                        onPressed: () {
                                          getInTime();
                                          setState(() {
                                            attSubmit = false;
                                            attendenceOutTime = "";
                                          });
                                        },
                                        child: FutureBuilder(
                                            future: getCurrentTime(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const CircularProgressIndicator(
                                                  color: Colors.white,
                                                );
                                              }
                                              if (snapshot.connectionState ==
                                                  ConnectionState.none) {
                                                return const Text(
                                                    'No connection!');
                                              }
                                              if (snapshot.hasError) {
                                                return const Text('Error');
                                              }
                                              return Text(
                                                attendenceInTime == ''
                                                    ? "In Time   "
                                                    : snapshot.data!.toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              );
                                            }),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    //Attendence out Time
                                    Container(
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
                                      width: 200,
                                      height: 50,
                                      child: TextButton(
                                        onPressed: () {
                                          getOutTime();
                                          setState(() {
                                            attSubmit = true;
                                            attendenceInTime = "";
                                          });
                                        },
                                        child: FutureBuilder(
                                            future: getCurrentTime(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const CircularProgressIndicator(
                                                  color: Colors.white,
                                                );
                                              }
                                              if (snapshot.connectionState ==
                                                  ConnectionState.none) {
                                                return const Text(
                                                    'No connection!');
                                              }
                                              if (snapshot.hasError) {
                                                return const Text('Error');
                                              }

                                              return Text(
                                                attendenceOutTime == ''
                                                    ? "Out Time"
                                                    : snapshot.data!.toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              );
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //submit button
                              attSubmit == false
                                  ? Container(
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
                                      width: 420,
                                      height: 50,
                                      margin: const EdgeInsets.only(top: 10),
                                      child: TextButton(
                                        onPressed: () {
                                          addInTimeToFireStore();
                                          setState(() {
                                            attendenceInTime = '';
                                            attendenceOutTime = '';
                                          });
                                        },
                                        child: const Text(
                                          "Submit In-Time",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  : Container(
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
                                      width: 420,
                                      height: 50,
                                      margin: const EdgeInsets.only(top: 10),
                                      child: TextButton(
                                        onPressed: () {
                                          addOutTimeToFireStore();
                                          setState(() {
                                            attendenceInTime = '';
                                            attendenceOutTime = '';
                                          });
                                        },
                                        child: const Text(
                                          "Submit Out-Time",
                                          style: TextStyle(
                                              color: Colors.white,
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

                        Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.6,
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                                        child: CircularProgressIndicator(
                                      color: MyColors.peach,
                                    ));
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
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
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                MyColors.peach,
                                                Color.fromARGB(
                                                    236, 144, 102, 251),
                                                MyColors.peach,
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(8),
                                          margin: const EdgeInsets.all(5),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                children: [
                                                  const Text(
                                                    "Email",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot.data!.docs[index]
                                                        ['email'],
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Text(
                                                    "Date",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot.data!.docs[index]
                                                        ['date'],
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Text(
                                                    "In Time",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot.data!.docs[index]
                                                        ['attendence_inTime'],
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const Text(
                                                    "Out Time",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot.data!.docs[index]
                                                        ['attendence_outTime'],
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      return const Center(
                                          child: CircularProgressIndicator(
                                        color: MyColors.peach,
                                      ));
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
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
                              // Task Starting Date...
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
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
                                        height: 50,
                                        width: 200,
                                        child: TextButton(
                                          onPressed: () {
                                            getStartDate();
                                            setState(() {
                                              taskEndDate = "";
                                              taskSubmit = false;
                                            });
                                          },
                                          child: FutureBuilder(
                                              future: getCurrentDate(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const CircularProgressIndicator(
                                                    color: Colors.white,
                                                  );
                                                }
                                                if (snapshot.connectionState ==
                                                    ConnectionState.none) {
                                                  return const Text(
                                                      'No connection!');
                                                }
                                                if (snapshot.hasError) {
                                                  return const Text('Error');
                                                }
                                                return Text(
                                                  taskStartDate == ''
                                                      ? "Starting Date"
                                                      : taskStartDate,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                );
                                              }),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
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
                                        height: 50,
                                        width: 200,
                                        child: TextButton(
                                          onPressed: () {
                                            getEndDate();
                                            setState(
                                              () {
                                                taskStartDate = '';
                                                taskSubmit = true;
                                              },
                                            );
                                          },
                                          child: FutureBuilder(
                                              future: getCurrentDate(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const CircularProgressIndicator(
                                                    color: Colors.white,
                                                  );
                                                }
                                                if (snapshot.connectionState ==
                                                    ConnectionState.none) {
                                                  return const Text(
                                                      'No connection!');
                                                }
                                                if (snapshot.hasError) {
                                                  return const Text('Error');
                                                }
                                                return Text(
                                                  taskEndDate == ""
                                                      ? "Ending Date"
                                                      : taskEndDate,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                );
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),

                                  //submit button
                                  const SizedBox(width: 50),
                                  taskSubmit == false
                                      ? Container(
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
                                          width: 420,
                                          height: 50,
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                addTaskToFireStore();
                                                taskSubmit = true;
                                                taskStartDate = '';
                                                taskEndDate = '';
                                              });
                                            },
                                            child: const Text(
                                              "Submit Start Date",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )
                                      : Container(
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
                                          width: 420,
                                          height: 50,
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          child: TextButton(
                                            onPressed: () {
                                              setState(() {
                                                updateTaskToFireStore();
                                                taskSubmit = false;
                                                taskStartDate = '';
                                                taskEndDate = '';
                                              });
                                            },
                                            child: const Text(
                                              "Submit End Date",
                                              style: TextStyle(
                                                  color: Colors.white,
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

                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const <Widget>[],
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.6,
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                                      child: CircularProgressIndicator(
                                        color: MyColors.peach,
                                      ),
                                    );
                                  }

                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
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
                                                Color.fromARGB(
                                                    236, 146, 103, 253),
                                                MyColors.peach,
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                children: [
                                                  const Text(
                                                    "Email",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot.data!.docs[index]
                                                        ['email'],
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot.data!.docs[index]
                                                        ['task_name'],
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot.data!.docs[index]
                                                        ['task_startDate'],
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot.data!.docs[index]
                                                        ['task_endDate'],
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot.data!.docs[index]
                                                        ['task_progress'],
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              Visibility(
                                                visible: snapshot.data!
                                                                .docs[index]
                                                            ['date'] ==
                                                        DateFormat.yMMMd()
                                                            .format(
                                                                DateTime.now())
                                                    ? true
                                                    : false,
                                                child: Column(
                                                  children: [
                                                    DropdownButton(
                                                      key: sKey,
                                                      focusColor: Colors
                                                          .deepPurple[300],
                                                      dropdownColor: Colors
                                                          .deepPurple[300],
                                                      iconEnabledColor:
                                                          Colors.white,
                                                      iconDisabledColor:
                                                          Colors.white,
                                                      hint: dropDownValue
                                                              .isEmpty
                                                          ? const Text(
                                                              "Task Status",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          : Text(dropDownValue),
                                                      items: _locations
                                                          .map((String val) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: val,
                                                          child: Text(val),
                                                        );
                                                      }).toList(),
                                                      onChanged: (val) {
                                                        setState(
                                                          () {
                                                            dropDownValue =
                                                                val!;
                                                          },
                                                        );
                                                      },
                                                    ),
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(80),
                                                        gradient:
                                                            const LinearGradient(
                                                          colors: [
                                                            MyColors.peach,
                                                            Color.fromARGB(237,
                                                                192, 167, 254),
                                                            MyColors.peach,
                                                          ],
                                                          begin: Alignment
                                                              .centerLeft,
                                                          end: Alignment
                                                              .centerRight,
                                                        ),
                                                      ),
                                                      child: TextButton(
                                                        onPressed: () {
                                                          updateProgressToFireStore();
                                                        },
                                                        style: TextButton
                                                            .styleFrom(
                                                                elevation: 10),
                                                        child: const Text(
                                                          "Submit",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                      ));
                                    },
                                  );
                                },
                              ),
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

  Future getInTime() async {
    setState(
      () {
        attendenceInTime = time!;
      },
    );
  }

  Future getStartDate() async {
    setState(
      () {
        taskStartDate = date!;
      },
    );
  }

  Future getOutTime() async {
    setState(
      () {
        attendenceOutTime = time!;
      },
    );
  }

  Future getEndDate() async {
    setState(
      () {
        taskEndDate = date!;
      },
    );
  }

  Future getDate() async {
    setState(
      () {
        todaysDate = DateFormat.yMMMd().format(_time).toString();
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
