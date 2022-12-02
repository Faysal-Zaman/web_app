import 'package:flutter/material.dart';

import '../global/colors.dart';

String? dropDownValue;
String? hintText;
GlobalKey dropDownKey = GlobalKey();
List<String> dropDownList = [];

class MyDropDownButton extends StatefulWidget {
  String dropDownValue;
  String hintText;
  GlobalKey dropDownKey = GlobalKey();
  List<String> dropDownList = [];

  MyDropDownButton({
    super.key,
    required this.dropDownKey,
    required this.dropDownList,
    required this.dropDownValue,
    required this.hintText,
  });

  @override
  State<MyDropDownButton> createState() => _MyDropDownButtonState();
}

class _MyDropDownButtonState extends State<MyDropDownButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.1,
      height: MediaQuery.of(context).size.height * 0.05,
      child: DropdownButton(
        key: widget.dropDownKey,
        focusColor: Colors.deepPurple[300],
        dropdownColor: MyColors.peach,
        iconEnabledColor: Colors.black,
        iconDisabledColor: Colors.black,
        icon: const Icon(Icons.arrow_drop_down),
        hint: widget.dropDownValue.isEmpty
            ? Text(
                widget.hintText,
                style: const TextStyle(color: Colors.black),
              )
            : Text(
                widget.dropDownValue,
                style: const TextStyle(color: Colors.black),
              ),
        items: widget.dropDownList.map((String val) {
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
              widget.dropDownValue = val!;
            },
          );
        },
      ),
    );
  }
}
