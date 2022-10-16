// import 'package:flutter/material.dart';

// class Rough extends StatefulWidget {
//   const Rough({super.key});

//   @override
//   State<Rough> createState() => _RoughState();
// }

// class _RoughState extends State<Rough> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//   crossAxisAlignment: CrossAxisAlignment.start,
//   children: [
//     Container(
//       padding: const EdgeInsets.all(10),
//       color: Colors.grey[500],
//       width: double.infinity,
//       height: 100,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Image.asset(
//             "assets/logo.png",
//             fit: BoxFit.contain,
//           ),
//           Row(
//             children: [
//               InkWell(
//                 onTap: () {
//                   setState(
//                     () {
//                       cond = true;
//                     },
//                   );
//                 },
//                 child: const Text(
//                   "Attendence",
//                   style: TextStyle(
//                     fontSize: 40,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 30),
//               InkWell(
//                 onTap: () {
//                   setState(
//                     () {
//                       cond = false;
//                     },
//                   );
//                 },
//                 child: const Text(
//                   "Task",
//                   style: TextStyle(
//                     fontSize: 40,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 30),
//               ElevatedButton.icon(
//                 onPressed: () async {
//                   auth.signOut();
//                 },
//                 style: TextButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   padding: const EdgeInsets.only(right: 30),
//                 ),
//                 icon: const Icon(
//                   Icons.logout,
//                   size: 50,
//                 ),
//                 label: const Text("Logout"),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//     cond == true
//         ? Column(
//             children: [
//               Container(
//                 color: Colors.white,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     const SizedBox(height: 20),
//                     SizedBox(
//                       height: 50,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           divider,
//                           /////////////////////////
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(todaysDate),
//                               TextButton.icon(
//                                 onPressed: () {
//                                   getDate();
//                                 },
//                                 icon: const Icon(Icons.sunny),
//                                 label: const Text("Pick Today's Date"),
//                               ),
//                             ],
//                           ),
//                           divider,
//                           /////////////////////////
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(attendenceInTime),
//                               TextButton.icon(
//                                 onPressed: () {
//                                   getInTime();
//                                 },
//                                 icon: const Icon(Icons.arrow_downward),
//                                 label: const Text("Pick In Time"),
//                               ),
//                             ],
//                           ),
//                           divider,
//                           //////////////////////
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(attendenceOutTime),
//                               TextButton.icon(
//                                 onPressed: () {
//                                   getOutTime();
//                                 },
//                                 icon: const Icon(Icons.arrow_upward),
//                                 label: const Text("Pick Out Time"),
//                               ),
//                             ],
//                           ),
//                           divider,
//                           ElevatedButton(
//                             onPressed: () {
//                               if (todaysDate == '' &&
//                                   attendenceInTime == '' &&
//                                   attendenceOutTime == '') {
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) => AlertDialog(
//                                     title:
//                                         const Text("Please Pick In/Out Time"),
//                                     actions: [
//                                       TextButton(
//                                         child: const Text("OK"),
//                                         onPressed: () {
//                                           Navigator.of(context).pop();
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               } else {
//                                 addAttendenceToFireStore();
//                               }
//                             },
//                             child: const Text("Submit"),
//                           ),
//                           divider,
//                           /////////////////////
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: const [
//                   Text(
//                     "     User Email",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     "          Date",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     "     In Time",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     "Out Time",
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 300,
//                 child: AttendenceList(divider: divider),
//               ),
//             ],
//           )
//         : Column(
//             children: [
//               Container(
//                 color: Colors.white,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const SizedBox(height: 30),
//                     SizedBox(
//                       height: 50,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           divider,
//                           /////////////////////////
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(todaysDate),
//                               TextButton.icon(
//                                 onPressed: () {
//                                   getDate();
//                                 },
//                                 icon: const Icon(Icons.sunny),
//                                 label: const Text("Pick Today's Date"),
//                               ),
//                             ],
//                           ),
//                           divider,
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(taskStaringTime),
//                               TextButton.icon(
//                                 onPressed: () {
//                                   getStartTime();
//                                 },
//                                 icon: const Icon(Icons.start),
//                                 label: const Text("Pick Start Time"),
//                               ),
//                             ],
//                           ),
//                           divider,
//                           //////////////////////
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(taskEndingTime),
//                               TextButton.icon(
//                                 onPressed: () {
//                                   getEndTime();
//                                 },
//                                 icon: const Icon(Icons.start),
//                                 label: const Text("Pick End Time"),
//                               ),
//                             ],
//                           ),
//                           divider,
//                           /////////////////////
//                           DropdownButton(
//                             hint: const Text(
//                                 'Task Progress'), // Not necessary for Option 1
//                             value: _selectedLocation,
//                             onChanged: (newValue) {
//                               setState(
//                                 () {
//                                   _selectedLocation = newValue;
//                                 },
//                               );
//                             },
//                             items: _locations.map((location) {
//                               return DropdownMenuItem(
//                                 value: location,
//                                 child: Text(location),
//                               );
//                             }).toList(),
//                           ),
//                           divider,
//                           ////////////////////
//                           ElevatedButton(
//                             onPressed: () {
//                               if (todaysDate == '' &&
//                                   taskStaringTime == '' &&
//                                   taskEndingTime == '' &&
//                                   _selectedLocation == "") {
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) => AlertDialog(
//                                     title: const Text(
//                                         "Please Pick Starting/Ending Time"),
//                                     actions: [
//                                       TextButton(
//                                         child: const Text("OK"),
//                                         onPressed: () {
//                                           Navigator.of(context).pop();
//                                         },
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               } else {
//                                 addTaskToFireStore();
//                               }
//                             },
//                             child: const Text("Submit"),
//                           ),
//                           divider,
//                           /////////////////////
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 30),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: const [
//                         Text(
//                           "User Email",
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           "               Date",
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           "     Task Name",
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           "Starts from",
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           "Ends till",
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           "         Task Progress",
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 300,
//                       child: TaskList(divider: divider),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//   ],
// );
//   }
// }

