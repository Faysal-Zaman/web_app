import 'package:flutter/material.dart';

class MyColors {
  MyColors._(); // this basically makes it so you can instantiate this class

  static const MaterialColor royalBlue = MaterialColor(
    0xff00539CFF,
    <int, Color>{
      500: Color(0xff00539CFF),
    },
  );

  static const MaterialColor peach = MaterialColor(
    0xffEEA47FFF,
    <int, Color>{
      500: Color(0xffEEA47FFF),
    },
  );
}
