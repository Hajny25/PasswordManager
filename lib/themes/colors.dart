import 'package:flutter/material.dart';

class MyColors {
  static Color backgroundDark = color("16161D");
  static Color ctaDark = color("B9BB47");
  static Color ctaLightDark = color("EEF09D");
  static Color ctaDarkDark = color("80814D");
  static Color cardDark = color("212130");
  static Color pictureBackgroundDark = color("2D2D3D");
  static Color barDark = color("1E1E24");
  static Color white = color("FFFFFF");

  static MaterialColor grey = MaterialColor(0x000000, <int, Color>{
    1: color("F4F4F4"),
    2: color("E6E6E6"),
    3: color("DADADA"),
    4: color("CDCDCD"),
    5: color("C0C0C0"),
    6: color("B4B4B4"),
    7: color("A7A7A7"),
    8: color("999999"),
    9: color("8D8D8D"),
   10: color("808080"),
   11: color("737373"),
   12: color("676767"),
   13: color("5A5A5A"),
   14: color("4D4D4D"),
   15: color("404040"),
   16: color("343434"),
   17: color("272727"),
   18: color("1A1A1A"),
   19: color("0E0E0E"),

  });
}

Color color(String rgbHex) {
  String s = "0xFF";
  s += rgbHex;
  return Color(int.parse(s));
}
