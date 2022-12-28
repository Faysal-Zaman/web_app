import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../auth/auth.dart';
import '../global/colors.dart';
import '../global/my_data.dart';

class AttendenceSystem extends StatefulWidget {
  const AttendenceSystem({super.key});

  @override
  State<AttendenceSystem> createState() => _AttendenceSystemState();
}

class _AttendenceSystemState extends State<AttendenceSystem> {
  static String inHours = '';
  static String inMinutes = '';
  String attendenceInTime = '';

  static String outHours = '';
  static String outMinutes = '';
  String attendenceOutTime = '';

  String inAmPmDropDownValue = '';
  String outAmPmDropDownValue = '';

  var auth = Auth();
  final userInfo = FirebaseAuth.instance.currentUser!;

  Set? listOfWholeDates = {};

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
                        width: MediaQuery.of(context).size.width * 0.1,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: DropdownButtonFormField(
                          key: inHoursKey,
                          menuMaxHeight:
                              MediaQuery.of(context).size.height * 0.5,
                          decoration: InputDecoration(
                              labelStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                              hintText: inHours.isEmpty ? "Hours" : inHours),
                          focusColor: Colors.white,
                          dropdownColor: MyColors.peach,
                          iconEnabledColor: Colors.black,
                          iconDisabledColor: Colors.black,
                          items: hoursDropDownList.map((String val) {
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
                                inHours = val!;
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Attendence in Minutes
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
                            hintText: inMinutes.isEmpty ? "Minutes" : inMinutes,
                          ),
                          key: inMinutesKey,
                          focusColor: Colors.white,
                          dropdownColor: MyColors.peach,
                          iconEnabledColor: Colors.black,
                          iconDisabledColor: Colors.black,
                          icon: const Icon(Icons.arrow_drop_down),
                          items: minutesDropDownList.map((String val) {
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
                                inMinutes = val!;
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      // set am and pm
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
                            hintText: inAmPmDropDownValue.isEmpty
                                ? "AM / PM"
                                : inAmPmDropDownValue,
                          ),
                          key: inAMPmKey,
                          focusColor: Colors.white,
                          dropdownColor: MyColors.peach,
                          iconEnabledColor: Colors.black,
                          iconDisabledColor: Colors.black,
                          icon: const Icon(Icons.arrow_drop_down),
                          items: amPmList.map(
                            (String val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(
                                  val,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            },
                          ).toList(),
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
                            if (inHours.isEmpty ||
                                inMinutes.isEmpty ||
                                inAmPmDropDownValue.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                      "Please fill all the fields in Out Time"),
                                ),
                              );
                            } else {
                              if (listOfWholeDates!.contains(DateFormat.yMMMd()
                                      .format(DateTime.now())
                                      .toString()) ||
                                  attendenceInTime == "Leave") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    padding: EdgeInsets.all(8.0),
                                    content: Text(
                                      "😱Oh! You already marked the attendence of this day...",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              } else {
                                setState(
                                  () {
                                    attendenceInTime =
                                        "$inHours:$inMinutes $inAmPmDropDownValue";
                                  },
                                );

                                // methods to update the attendence
                                addInTimeToFireStore();
                                setState(
                                  () {
                                    inHours = "";
                                    inMinutes = "";
                                    inAmPmDropDownValue = "";
                                  },
                                );
                              }
                            }
                          },
                          style: TextButton.styleFrom(elevation: 10),
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
                            hintText: outHours.isEmpty ? "Hours" : outHours,
                          ),
                          key: outHoursKey,
                          focusColor: Colors.white,
                          dropdownColor: MyColors.peach,
                          iconEnabledColor: Colors.black,
                          iconDisabledColor: Colors.black,
                          icon: const Icon(Icons.arrow_drop_down),
                          items: hoursDropDownList.map(
                            (String val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(
                                  val,
                                  style: const TextStyle(color: Colors.black),
                                ),
                              );
                            },
                          ).toList(),
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
                            hintText:
                                outMinutes.isEmpty ? "Minutes" : outMinutes,
                          ),
                          key: outMinutesKey,
                          focusColor: Colors.white,
                          dropdownColor: MyColors.peach,
                          iconEnabledColor: Colors.black,
                          iconDisabledColor: Colors.black,
                          icon: const Icon(Icons.arrow_drop_down),
                          items: minutesDropDownList.map((String val) {
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
                                outMinutes = val!;
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Attendence out AmPm
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
                            hintText: outAmPmDropDownValue.isEmpty
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
                                style: const TextStyle(color: Colors.black),
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
                            if (outHours.isEmpty ||
                                outMinutes.isEmpty ||
                                outAmPmDropDownValue.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
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
                          style: TextButton.styleFrom(elevation: 10),
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
                  color: MyColors.peach,
                  border: Border.all(),
                ),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Attendence")
                      .doc(FirebaseAuth.instance.currentUser!.email)
                      .collection(
                          DateFormat.MMM().format(DateTime.now()).toString())
                      .orderBy("attendence_inTime", descending: true)
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
                        if (snapshot.hasData) {
                          listOfWholeDates!
                              .add(snapshot.data!.docs[index]['date']);
                          return Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      "Email",
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!.docs[index]['email'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      "Date",
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!.docs[index]['date'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      "In Time",
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!.docs[index]
                                          ['attendence_inTime'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      "Out Time",
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data!.docs[index]
                                          ['attendence_outTime'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
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

  Future<String> getInTime() async {
    setState(
      () {
        // attendenceInTime = time!;
      },
    );
    return attendenceInTime;
  }

  Future<String> getOutTime() async {
    setState(
      () {
        // attendenceOutTime = time!;
      },
    );
    return attendenceOutTime;
  }

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
}
