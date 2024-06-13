import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Constants {
  static Color primary = const Color(0xFF2321AA);
  static Color secondary = const Color(0xFF80C3DD);
  static Color bg1 = const Color(0xFFF5F6FA);
  static Color white = Colors.white;
  static Color black = Colors.black;
  static Color grey = Colors.grey;
  static Color blue = Colors.blue;
  static Color green = Colors.green;
  static Color orange = Colors.orange;
  static Color red = const Color(0xFFEB2012);

  static TextStyle poppins(
      double fontSize, FontWeight fontWeight, Color color) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
