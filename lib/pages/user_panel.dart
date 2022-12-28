import 'dart:html';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:web_app/module/attendence_system.dart';
import 'package:web_app/module/task_system.dart';
import 'package:web_app/widgets/my_appbar_widget.dart';
import 'package:web_app/widgets/my_drawer.dart';

import '../auth/auth.dart';
import '../global/colors.dart';
import '../global/my_data.dart';

class UserPanelScreen extends StatefulWidget {
  const UserPanelScreen({super.key});

  @override
  State<UserPanelScreen> createState() => _UserPanelScreenState();
}

class _UserPanelScreenState extends State<UserPanelScreen> {
  bool cond = true;

  int _selectedIndex = 0;

  // String? _selectedLocation;

  // Reference of Auth...
  var auth = Auth();
  final userInfo = FirebaseAuth.instance.currentUser!;
  final DateTime _time = DateTime.now();
  String? time;
  String? date;

  Set? listOfWholeDates = {};

  /// for getting the actual time via api

  Future<void> getCurrentTime() async {
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

      setState(() {
        // date = DateFormat.MMMd().format(dateTime).toString();
        time = DateFormat.jm().format(dateTime).toString();
      });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OOPS! There is a connection problem with Time Server"),
        ),
      );
    }
  }

  Future<void> getCurrentDate() async {
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

      setState(() {
        date = DateFormat.MMMd().format(dateTime).toString();
        // time = DateFormat.jm().format(dateTime).toString();
      });
    } else {
      // ignore: use_build_context_synchronously
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
    // getCurrentTime();
    // getCurrentDate();
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint("The actual time is $time");
    // debugPrint("The actual date is $date");
    // print the listOfWholeDates here
    print("The listOfWholeDates are : " + listOfWholeDates.toString());
    return Scaffold(
      endDrawer: _selectedIndex == 0 ? const MyDrawerWidget() : null,
      appBar: const MyAppBarWidget(),
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
              leading: Container(
                margin: const EdgeInsets.only(bottom: 80, right: 10),
                padding: const EdgeInsets.all(10),
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
              elevation: 1,
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
                  label: FittedBox(
                    child: Text(
                      'Attendence',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
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
                  label: FittedBox(
                    child: Text(
                      'Task',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ),
              ],
              selectedIconTheme: const IconThemeData(color: Colors.white),
              unselectedIconTheme: const IconThemeData(color: Colors.black),
              selectedLabelTextStyle: const TextStyle(color: Colors.white),
            ),

            _selectedIndex == 0 ? const AttendenceSystem() : const TaskSystem(),
          ],
        ),
      ),
    );
  }

  String todaysDate = '';
  Future<String> getDate() async {
    setState(
      () {
        todaysDate = DateFormat.yMMMd().format(time! as DateTime).toString();
      },
    );
    return todaysDate;
  }

  //DateFormat.yMMMd().format(DateTime.now()).toString()
}
