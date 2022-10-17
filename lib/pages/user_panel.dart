import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  Widget divider = const VerticalDivider(
    color: Colors.black,
    // thickness: 1,
  );

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

  Future getInTime() async {
    setState(() {
      attendenceInTime = DateFormat.jm().format(DateTime.now()).toString();
    });
  }

  Future getStartTime() async {
    setState(() {
      taskStaringTime = DateFormat.jm().format(DateTime.now()).toString();
    });
  }

  Future getOutTime() async {
    setState(() {
      attendenceOutTime = DateFormat.jm().format(DateTime.now()).toString();
    });
  }

  Future getEndTime() async {
    setState(() {
      taskEndingTime = DateFormat.jm().format(DateTime.now()).toString();
    });
  }

  Future getDate() async {
    setState(() {
      todaysDate = DateFormat.yMMMd().format(DateTime.now()).toString();
    });
  }

  // var attendenceReference = FirebaseFirestore.instance
  //     .collection("Attendence")
  //     .doc(FirebaseAuth.instance.currentUser!.uid)
  //     .collection(DateFormat.yMMMd().format(DateTime.now()).toString())
  //     .doc();

  // var taskReference = FirebaseFirestore.instance
  //     .collection("Task")
  //     .doc(FirebaseAuth.instance.currentUser!.email.toString())
  //     .collection(DateFormat.MMM().format(DateTime.now()).toString())
  //     .doc(FirebaseAuth.instance.currentUser!.uid.toString());

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

  // Future<void> addTaskToFireStore() async {
  //   await taskReference
  //       .set({
  //         'email': userInfo.email.toString(),
  //         'date': todaysDate,
  //         'user_id': userInfo.uid.toString(),
  //         'task_name': '???',
  //         'task_startTime': taskStaringTime,
  //         'task_endTime': taskEndingTime,
  //         'task_progress': _selectedLocation,
  //       })
  //       .then((value) => print("Information Added"))
  //       .catchError((error) => print("Failed to add Information: $error"));
  // }

  bool attSubmit = false;

  @override
  Widget build(BuildContext context) {
    Stream attendenceStream = FirebaseFirestore.instance
        .collection("Attendence")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(DateFormat.yMMMd().format(DateTime.now()).toString())
        .doc()
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Attendence & Task Management",
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
                margin: const EdgeInsets.all(5),
                child: ElevatedButton.icon(
                  onPressed: () async {
                    auth.signOut();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green,
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
                  label: Text('Attendence'),
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
                  label: Text('Task'),
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
                                            backgroundColor: Colors.blue[100]),
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
                                            backgroundColor: Colors.blue[100]),
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
                                      width: 220,
                                      height: 70,
                                      margin: const EdgeInsets.only(top: 10),
                                      child: ElevatedButton(
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
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 220,
                                      height: 70,
                                      margin: const EdgeInsets.only(top: 10),
                                      child: ElevatedButton(
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
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),

                        //////////////////////
                        ///
                        /// List of Attendence
                        ///
                        //////////////////////

                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                          child: Column(
                            children: [
                              Container(
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
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
                                          child: Text("loading"));
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
                                                Text(snapshot.data!.docs[index]
                                                    ['email']),
                                                Text(snapshot.data!.docs[index]
                                                    ['date']),
                                                Text(snapshot.data!.docs[index]
                                                    ['attendence_inTime']),
                                                Text(snapshot.data!.docs[index]
                                                    ['attendence_outTime']),
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
                : Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 1200,
                      height: 550,
                      color: Colors.amber,
                      // child: Column(
                      //   children: [
                      //     Container(
                      //       color: Colors.white,
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         children: [
                      //           const SizedBox(height: 30),
                      //           SizedBox(
                      //             height: 50,
                      //             child: Row(
                      //               mainAxisAlignment:
                      //                   MainAxisAlignment.spaceAround,
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.center,
                      //               children: [
                      //                 divider,
                      //                 /////////////////////////
                      //                 Column(
                      //                   mainAxisAlignment:
                      //                       MainAxisAlignment.center,
                      //                   children: [
                      //                     Text(todaysDate),
                      //                     TextButton.icon(
                      //                       onPressed: () {
                      //                         getDate();
                      //                       },
                      //                       icon: const Icon(Icons.sunny),
                      //                       label:
                      //                           const Text("Pick Today's Date"),
                      //                     ),
                      //                   ],
                      //                 ),
                      //                 divider,
                      //                 Column(
                      //                   mainAxisAlignment:
                      //                       MainAxisAlignment.center,
                      //                   children: [
                      //                     Text(taskStaringTime),
                      //                     TextButton.icon(
                      //                       onPressed: () {
                      //                         getStartTime();
                      //                       },
                      //                       icon: const Icon(Icons.start),
                      //                       label:
                      //                           const Text("Pick Start Time"),
                      //                     ),
                      //                   ],
                      //                 ),
                      //                 divider,
                      //                 //////////////////////
                      //                 Column(
                      //                   mainAxisAlignment:
                      //                       MainAxisAlignment.center,
                      //                   children: [
                      //                     Text(taskEndingTime),
                      //                     TextButton.icon(
                      //                       onPressed: () {
                      //                         getEndTime();
                      //                       },
                      //                       icon: const Icon(Icons.start),
                      //                       label: const Text("Pick End Time"),
                      //                     ),
                      //                   ],
                      //                 ),
                      //                 divider,
                      //                 /////////////////////
                      //                 DropdownButton(
                      //                   hint: const Text(
                      //                       'Task Progress'), // Not necessary for Option 1
                      //                   value: _selectedLocation,
                      //                   onChanged: (newValue) {
                      //                     setState(
                      //                       () {
                      //                         _selectedLocation = newValue;
                      //                       },
                      //                     );
                      //                   },
                      //                   items: _locations.map((location) {
                      //                     return DropdownMenuItem(
                      //                       value: location,
                      //                       child: Text(location),
                      //                     );
                      //                   }).toList(),
                      //                 ),
                      //                 divider,
                      //                 ////////////////////
                      //                 ElevatedButton(
                      //                   onPressed: () {
                      //                     if (todaysDate == '' &&
                      //                         taskStaringTime == '' &&
                      //                         taskEndingTime == '' &&
                      //                         _selectedLocation == "") {
                      //                       showDialog(
                      //                         context: context,
                      //                         builder: (context) => AlertDialog(
                      //                           title: const Text(
                      //                               "Please Pick Starting/Ending Time"),
                      //                           actions: [
                      //                             TextButton(
                      //                               child: const Text("OK"),
                      //                               onPressed: () {
                      //                                 Navigator.of(context)
                      //                                     .pop();
                      //                               },
                      //                             ),
                      //                           ],
                      //                         ),
                      //                       );
                      //                     } else {
                      //                       addTaskToFireStore();
                      //                     }
                      //                   },
                      //                   child: const Text("Submit"),
                      //                 ),
                      //                 divider,
                      //                 /////////////////////
                      //               ],
                      //             ),
                      //           ),
                      //           const SizedBox(height: 30),
                      //           Row(
                      //             mainAxisAlignment:
                      //                 MainAxisAlignment.spaceEvenly,
                      //             children: const [
                      //               Text(
                      //                 "User Email",
                      //                 style: TextStyle(
                      //                   fontSize: 20,
                      //                   fontWeight: FontWeight.bold,
                      //                 ),
                      //               ),
                      //               Text(
                      //                 "               Date",
                      //                 style: TextStyle(
                      //                   fontSize: 20,
                      //                   fontWeight: FontWeight.bold,
                      //                 ),
                      //               ),
                      //               Text(
                      //                 "     Task Name",
                      //                 style: TextStyle(
                      //                   fontSize: 20,
                      //                   fontWeight: FontWeight.bold,
                      //                 ),
                      //               ),
                      //               Text(
                      //                 "Starts from",
                      //                 style: TextStyle(
                      //                   fontSize: 20,
                      //                   fontWeight: FontWeight.bold,
                      //                 ),
                      //               ),
                      //               Text(
                      //                 "Ends till",
                      //                 style: TextStyle(
                      //                   fontSize: 20,
                      //                   fontWeight: FontWeight.bold,
                      //                 ),
                      //               ),
                      //               Text(
                      //                 "         Task Progress",
                      //                 style: TextStyle(
                      //                   fontSize: 20,
                      //                   fontWeight: FontWeight.bold,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //           SizedBox(
                      //             height: 300,
                      //             child: TaskList(divider: divider),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
