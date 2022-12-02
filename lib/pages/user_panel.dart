import 'dart:html';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../auth/auth.dart';
import '../global/colors.dart';
import '../global/my_data.dart';

class UserPanelScreen extends StatefulWidget {
  const UserPanelScreen({super.key});

  @override
  State<UserPanelScreen> createState() => _UserPanelScreenState();
}

class _UserPanelScreenState extends State<UserPanelScreen> {
  static String inHours = '';
  static String inMinutes = '';
  String attendenceInTime = '';

  static String outHours = '';
  static String outMinutes = '';
  String attendenceOutTime = '';

  String taskStartDate = '';
  String taskEndDate = '';

  String startDate = '';
  String endDate = '';
  String taskMonth = '';

  String taskStartMonth = '';
  String taskEndMonth = '';

  String todaysDate = '';
  bool taskSubmit = false;
  bool attSubmit = false;
  bool cond = true;

  String inAmPmDropDownValue = '';
  String outAmPmDropDownValue = '';

  static String dropDownValue = '';

  final sKey = GlobalKey();

  // String? _selectedLocation;

  // Reference of Auth...
  var auth = Auth();
  final userInfo = FirebaseAuth.instance.currentUser!;
  final DateTime _time = DateTime.now();
  String? time;
  String? date;

  // initialize an index
  int _selectedIndex = 0;

  static final List<String> dropDownList = [
    'is Completed',
    'in Progress',
  ];

  /// for getting the actual time via api

  Future<String> getCurrentTime() async {
    var url = Uri.parse('http://worldtimeapi.org/api/timezone/Asia/Karachi');
    var response = await http.get(url);
    var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      var dateNTime = jsonResponse['datetime'];
      // ignore: prefer_interpolation_to_compose_strings
      debugPrint("response.body => " + jsonResponse['utc_offset']);
      var ucOffset = jsonResponse['utc_offset'].toString().substring(1, 3);
      debugPrint("response.body => $ucOffset");

      DateTime dateTime = DateTime.parse(dateNTime);
      dateTime = dateTime.add(Duration(hours: int.parse(ucOffset)));
      debugPrint('dateTime  => $dateTime');

      debugPrint("dateFormat.jm() => ${DateFormat.jm().format(dateTime)}");
      debugPrint("dateFormat.jm() => ${DateFormat.Hm().format(dateTime)}");

      // date = DateFormat.MMMd().format(dateTime).toString();
      time = DateFormat.jm().format(dateTime).toString();
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OOPS! There is a connection problem with Time Server"),
        ),
      );
    }
    return time!;
  }

  Future<String> getCurrentDate() async {
    var url = Uri.parse('http://worldtimeapi.org/api/timezone/Asia/Karachi');
    var response = await http.get(url);
    var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      var dateNTime = jsonResponse['datetime'];
      // ignore: prefer_interpolation_to_compose_strings
      debugPrint("response.body => " + jsonResponse['utc_offset']);
      var ucOffset = jsonResponse['utc_offset'].toString().substring(1, 3);
      debugPrint("response.body => $ucOffset");

      DateTime dateTime = DateTime.parse(dateNTime);
      dateTime = dateTime.add(Duration(hours: int.parse(ucOffset)));
      debugPrint('dateTime  => $dateTime');

      debugPrint("dateFormat.jm() => ${DateFormat.jm().format(dateTime)}");
      debugPrint("dateFormat.jm() => ${DateFormat.Hm().format(dateTime)}");

      date = DateFormat.MMMd().format(dateTime).toString();
      // return time = DateFormat.jm().format(dateTime).toString();
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OOPS! There is a connection problem with Time Server"),
        ),
      );
    }
    return date!;
  }

  @override
  void initState() {
    super.initState();
    // getCurrentTime();
    // getCurrentDate();
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
            backgroundColor: const Color.fromARGB(255, 13, 71, 161),
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
            color: const Color.fromARGB(255, 13, 71, 161),
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
                              // In Time Portion
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Text
                                    const Text(
                                      "   In Time :",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    //Attendence in Time
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      child: DropdownButtonFormField(
                                        key: inHoursKey,
                                        menuMaxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        decoration: InputDecoration(
                                            labelStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                            labelText: inHours.isEmpty
                                                ? "Hours"
                                                : inHours),
                                        focusColor: Colors.white,
                                        dropdownColor: MyColors.peach,
                                        iconEnabledColor: Colors.black,
                                        iconDisabledColor: Colors.black,
                                        items:
                                            hoursDropDownList.map((String val) {
                                          return DropdownMenuItem<String>(
                                            value: val,
                                            child: Text(
                                              val,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          setState(
                                            () {
                                              inHours = val!;
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    // Attendence in Minutes
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      child: DropdownButtonFormField<String>(
                                        menuMaxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        decoration: InputDecoration(
                                          labelStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                          labelText: inMinutes.isEmpty
                                              ? "Minutes"
                                              : inMinutes,
                                        ),
                                        key: inMinutesKey,
                                        focusColor: Colors.white,
                                        dropdownColor: MyColors.peach,
                                        iconEnabledColor: Colors.black,
                                        iconDisabledColor: Colors.black,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        items: minutesDropDownList
                                            .map((String val) {
                                          return DropdownMenuItem<String>(
                                            value: val,
                                            child: Text(
                                              val,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          setState(
                                            () {
                                              inMinutes = val!;
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    // set am and pm
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      child: DropdownButtonFormField<String>(
                                        menuMaxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        decoration: InputDecoration(
                                          labelStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                          labelText: inAmPmDropDownValue.isEmpty
                                              ? "AM / PM"
                                              : inAmPmDropDownValue,
                                        ),
                                        key: inAMPmKey,
                                        focusColor: Colors.white,
                                        dropdownColor: MyColors.peach,
                                        iconEnabledColor: Colors.black,
                                        iconDisabledColor: Colors.black,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        items: amPmList.map((String val) {
                                          return DropdownMenuItem<String>(
                                            value: val,
                                            child: Text(
                                              val,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          setState(
                                            () {
                                              inAmPmDropDownValue = val!;
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    // submit button
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.12,
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
                                          if (inHours.isEmpty ||
                                              inMinutes.isEmpty ||
                                              inAmPmDropDownValue.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                backgroundColor: Colors.red,
                                                content: Text(
                                                    "Please fill all the fields in Out Time"),
                                              ),
                                            );
                                          } else {
                                            setState(() {
                                              attendenceInTime =
                                                  "$inHours:$inMinutes $inAmPmDropDownValue";
                                            });
                                            // methods to update the attendence
                                            addInTimeToFireStore();
                                            setState(() {
                                              inHours = "";
                                              inMinutes = "";
                                              inAmPmDropDownValue = "";
                                            });
                                          }
                                        },
                                        style:
                                            TextButton.styleFrom(elevation: 10),
                                        child: const FittedBox(
                                          child: Text(
                                            "Submit in Time",
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
                              ),
                              // Out Time Portion
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text(
                                      "Out Time :",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    // Attendence out Hours
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      child: DropdownButtonFormField<String>(
                                        menuMaxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        decoration: InputDecoration(
                                          labelStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                          labelText: outHours.isEmpty
                                              ? "Hours"
                                              : outHours,
                                        ),
                                        key: outHoursKey,
                                        focusColor: Colors.white,
                                        dropdownColor: MyColors.peach,
                                        iconEnabledColor: Colors.black,
                                        iconDisabledColor: Colors.black,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        items:
                                            hoursDropDownList.map((String val) {
                                          return DropdownMenuItem<String>(
                                            value: val,
                                            child: Text(
                                              val,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          setState(
                                            () {
                                              outHours = val!;
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    // Attendence out Minutes
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      child: DropdownButtonFormField<String>(
                                        menuMaxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        decoration: InputDecoration(
                                          labelStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                          labelText: outMinutes.isEmpty
                                              ? "Minutes"
                                              : outMinutes,
                                        ),
                                        key: outMinutesKey,
                                        focusColor: Colors.white,
                                        dropdownColor: MyColors.peach,
                                        iconEnabledColor: Colors.black,
                                        iconDisabledColor: Colors.black,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        items: minutesDropDownList
                                            .map((String val) {
                                          return DropdownMenuItem<String>(
                                            value: val,
                                            child: Text(
                                              val,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          setState(
                                            () {
                                              outMinutes = val!;
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    // Attendence out AmPm
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      child: DropdownButtonFormField<String>(
                                        menuMaxHeight:
                                            MediaQuery.of(context).size.height *
                                                0.5,
                                        decoration: InputDecoration(
                                          labelStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                          labelText:
                                              outAmPmDropDownValue.isEmpty
                                                  ? "AM / PM"
                                                  : outAmPmDropDownValue,
                                        ),
                                        key: outAMPmKey,
                                        focusColor: Colors.white,
                                        dropdownColor: MyColors.peach,
                                        iconEnabledColor: Colors.black,
                                        iconDisabledColor: Colors.black,
                                        icon: const Icon(Icons.arrow_drop_down),
                                        items: amPmList.map((String val) {
                                          return DropdownMenuItem<String>(
                                            value: val,
                                            child: Text(
                                              val,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (val) {
                                          setState(
                                            () {
                                              outAmPmDropDownValue = val!;
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    // Submit Out Time Button
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.12,
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
                                          if (outHours.isEmpty ||
                                              outMinutes.isEmpty ||
                                              outAmPmDropDownValue.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                backgroundColor: Colors.red,
                                                content: Text(
                                                    "Please fill all the fields in Out Time"),
                                              ),
                                            );
                                          } else {
                                            setState(() {
                                              attendenceOutTime =
                                                  "$outHours:$outMinutes $outAmPmDropDownValue";
                                            });
                                            // here the mehtod to submit the out time
                                            addOutTimeToFireStore();
                                            setState(() {
                                              outHours = "";
                                              outMinutes = "";
                                              outAmPmDropDownValue = "";
                                            });
                                          }
                                        },
                                        style:
                                            TextButton.styleFrom(elevation: 10),
                                        child: const FittedBox(
                                          child: Text(
                                            "Submit out Time",
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
                              height: MediaQuery.of(context).size.height * 0.65,
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
                                    .orderBy("attendence_inTime",
                                        descending: true)
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: DropdownButtonFormField<String>(
                                          menuMaxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
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
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          items: monthsList.map((String val) {
                                            return DropdownMenuItem<String>(
                                              value: val,
                                              child: Text(
                                                val,
                                                style: const TextStyle(
                                                    color: Colors.black),
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: DropdownButtonFormField<String>(
                                          menuMaxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          decoration: InputDecoration(
                                            labelStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                            labelText: startDate == ""
                                                ? "Date"
                                                : startDate,
                                          ),
                                          key: taskStartDateKey,
                                          focusColor: Colors.white,
                                          dropdownColor: MyColors.peach,
                                          iconEnabledColor: Colors.black,
                                          iconDisabledColor: Colors.black,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          items: datesDropDownList
                                              .map((String val) {
                                            return DropdownMenuItem<String>(
                                              value: val,
                                              child: Text(
                                                val,
                                                style: const TextStyle(
                                                    color: Colors.black),
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.12,
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
                                            if (taskStartMonth == "" ||
                                                startDate == "") {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
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
                                                taskStartDate =
                                                    "$taskStartMonth $startDate";
                                              });
                                              addTaskToFireStore();
                                              setState(() {
                                                taskStartMonth = "";
                                                startDate = "";
                                              });
                                            }
                                          },
                                          style: TextButton.styleFrom(
                                              elevation: 10),
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: DropdownButtonFormField<String>(
                                          menuMaxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          decoration: InputDecoration(
                                            labelStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                            labelText: taskEndMonth.isEmpty
                                                ? "Month"
                                                : taskEndMonth,
                                          ),
                                          key: taskEndMonthsKey,
                                          focusColor: Colors.white,
                                          dropdownColor: MyColors.peach,
                                          iconEnabledColor: Colors.black,
                                          iconDisabledColor: Colors.black,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          items: monthsList.map((String val) {
                                            return DropdownMenuItem<String>(
                                              value: val,
                                              child: Text(
                                                val,
                                                style: const TextStyle(
                                                    color: Colors.black),
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.1,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        child: DropdownButtonFormField<String>(
                                          menuMaxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          decoration: InputDecoration(
                                            labelStyle: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                            labelText: endDate.isEmpty
                                                ? "Date"
                                                : endDate,
                                          ),
                                          key: taskEndDateKey,
                                          focusColor: Colors.white,
                                          dropdownColor: MyColors.peach,
                                          iconEnabledColor: Colors.black,
                                          iconDisabledColor: Colors.black,
                                          icon:
                                              const Icon(Icons.arrow_drop_down),
                                          items: datesDropDownList
                                              .map((String val) {
                                            return DropdownMenuItem<String>(
                                              value: val,
                                              child: Text(
                                                val,
                                                style: const TextStyle(
                                                    color: Colors.black),
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.12,
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
                                            if (taskEndMonth == "" ||
                                                endDate == "") {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
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
                                                taskEndDate =
                                                    "$taskEndMonth $endDate";
                                              });
                                              updateTaskToFireStore();
                                              setState(() {
                                                taskEndMonth = "";
                                                endDate = "";
                                              });
                                            }
                                          },
                                          style: TextButton.styleFrom(
                                              elevation: 10),
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
                                    .doc(FirebaseAuth
                                        .instance.currentUser!.email)
                                    .collection(DateFormat.MMM()
                                        .format(DateTime.now())
                                        .toString())
                                    .orderBy("task_startDate", descending: true)
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
                                                      hint:
                                                          dropDownValue.isEmpty
                                                              ? const Text(
                                                                  "Task Status",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                )
                                                              : Text(
                                                                  dropDownValue,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                      items: dropDownList
                                                          .map((String val) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: val,
                                                          child: Text(
                                                            val,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ),
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

  Future<String> getInTime() async {
    setState(
      () {
        attendenceInTime = time!;
      },
    );
    return attendenceInTime;
  }

  Future<String> getStartDate() async {
    setState(
      () {
        taskStartDate = date!;
      },
    );
    return taskStartDate;
  }

  Future<String> getOutTime() async {
    setState(
      () {
        attendenceOutTime = time!;
      },
    );
    return attendenceOutTime;
  }

  Future<String> getEndDate() async {
    setState(
      () {
        taskEndDate = date!;
      },
    );
    return taskEndDate;
  }

  Future<String> getDate() async {
    setState(
      () {
        todaysDate = DateFormat.yMMMd().format(_time).toString();
      },
    );
    return todaysDate;
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
