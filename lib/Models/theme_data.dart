import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle _style(
  String family,
  double fontSize,
  FontWeight weight,
  Color color, {
  Shadow shadow,
}) {
  return TextStyle(
    fontFamily: family,
    fontSize: fontSize,
    fontWeight: weight,
    color: color,
    letterSpacing: 0.0,
    wordSpacing: 1.0,
    shadows: [shadow],
  );
}

TextTheme textTheme() {
  return TextTheme(
    displayLarge: GoogleFonts.openSans(
      fontWeight: FontWeight.normal,
      fontSize: 20.0,
      color: Colors.black,
      letterSpacing: 0.0,
      wordSpacing: 1.0,
      shadows: [],
    ),
    displayMedium: _style(
      'Rockwell',
      20.0,
      FontWeight.normal,
      Color.fromARGB(255, 72, 73, 75),
      shadow: Shadow(
        blurRadius: 1.0,
        color: Colors.black.withOpacity(0.3),
        offset: Offset(1, 1),
      ),
    ),
    displaySmall: _style(
      'Roboto',
      12.0,
      FontWeight.normal,
      Colors.white,
      shadow: Shadow(
        blurRadius: 2,
        color: Colors.black.withOpacity(0.6),
        offset: Offset(0.5, 0.5),
      ),
    ),
    headlineLarge: _style(
      'Gabriola',
      22.0,
      FontWeight.bold,
      Colors.white,
      shadow: Shadow(
        blurRadius: 3,
        color: Colors.black,
        offset: Offset(1.0, 1.0),
      ),
    ),
    headlineMedium: GoogleFonts.abhayaLibre(
      fontSize: 30.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,
      letterSpacing: 0.0,
      wordSpacing: 1.0,
      shadows: [
        Shadow(
          blurRadius: 5.0,
          color: Colors.black.withOpacity(0.6),
          offset: Offset(1.0, 1.0),
        ),
      ],
    ),
    headlineSmall: _style(
      'Constan',
      30.0,
      FontWeight.normal,
      Color.fromARGB(255, 0, 88, 122),
      shadow: Shadow(
        blurRadius: 1,
        color: Colors.black.withOpacity(0.4),
        offset: Offset(1.0, 1.0),
      ),
    ),
    titleLarge: _style('Pristina', 30.0, FontWeight.bold, Color.fromARGB(255, 0, 88, 122)),
    titleMedium: _style('Gothic', 20.0, FontWeight.normal, Colors.white),
    titleSmall: _style(
      'Niagara Solid',
      25.0,
      FontWeight.normal,
      Color.fromARGB(255, 115, 111, 114),
    ),
    bodyLarge: GoogleFonts.philosopher(
      fontSize: 30.0,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.0,
      wordSpacing: 1.0,
      color: Color.fromARGB(255, 89, 89, 89),
      shadows: [],
    ),
    bodyMedium: _style('Iskola Potha', 17.0, FontWeight.normal, Colors.black),
    bodySmall: _style('AgencyFB', 25.0, FontWeight.normal, Colors.black),
    labelLarge: _style('Scriptina', 25.0, FontWeight.bold, Colors.white),
    labelMedium: _style(
      'Lemon Jelly',
      20.0,
      FontWeight.normal,
      Color.fromARGB(255, 200, 62, 77),
    ),
  );
}

TextTheme primaryTextTheme() {
  return TextTheme(
    displayLarge: _style(
      'Dancing Script',
      26.0,
      FontWeight.normal,
      Colors.white,
      shadow: Shadow(
        color: Colors.black.withOpacity(0.5),
        blurRadius: 3,
        offset: Offset(1, 1.5),
      ),
    ),
    displayMedium: _style(
      'Falcon',
      35.0,
      FontWeight.normal,
      Colors.white,
      shadow: Shadow(
        color: Colors.black.withOpacity(0.6),
        offset: Offset(2, 2),
        blurRadius: 5,
      ),
    ),
    displaySmall: _style('Crash', 17.0, FontWeight.bold, Colors.black),
    headlineLarge: _style(
      'Lemon Jelly',
      16.0,
      FontWeight.normal,
      Color.fromARGB(255, 0, 135, 145),
    ),
    headlineMedium: _style(
      'Warna',
      27.0,
      FontWeight.bold,
      Color.fromARGB(255, 72, 73, 75),
      shadow: Shadow(
        color: Colors.grey.shade600,
        blurRadius: 2,
        offset: Offset(1, 1),
      ),
    ),
    headlineSmall: _style('Sylfaen', 19.0, FontWeight.normal, Colors.black),
  );
}
