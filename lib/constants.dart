import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// BACKGROUND

const Color kBackgroundColor = Color(0xff363835);

// BUTTON FONT AND STYLE
final TextStyle kGoogleFonts = GoogleFonts.rancho(
  textStyle: const TextStyle(
      fontSize: 22.0,
      color: Colors.white,
      fontWeight: FontWeight.w700,
      letterSpacing: 2.0),
);
final TextStyle kMainMenuFonts = GoogleFonts.rancho(
  textStyle: const TextStyle(
      fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.w700),
);

final TextStyle kTextFieldInputStyle = GoogleFonts.rancho(
  textStyle: const TextStyle(
      fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.w700),
);

const Color kButtonColor = Color(0xff415A30);

// BUTTON TITLES
const String kLoginTitle = 'Log in';
const String kRegisterTitle = 'Register';
const String kSubmit = 'Submit';

// TEXT FIELD DECORATION

const kTextFieldDecoration = InputDecoration(
  hintStyle: TextStyle(color: Colors.white),
  labelStyle: TextStyle(color: Colors.white),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kButtonColor, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: kButtonColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

// RESERVATION DETAILS SCREEN

const TextStyle kReservationDetails =
    TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500, color: Colors.white);

// dropdownbutton list

List<String> dropdownButtonList = [
  '8:00 - 10:00',
  '10:00 - 12:00',
  '12:00 - 14:00',
  '14:00 - 16:00',
];

// TITLE COLORS
const Color color1 = Color(0xff878986);
const Color color2 = Color.fromARGB(255, 255, 88, 141);
const Color color3 = Color.fromARGB(255, 147, 255, 179);
const Color color4 = Color.fromARGB(255, 255, 238, 88);
const Color color5 = Color.fromARGB(255, 7, 56, 22);

final colorizeColors = [
  color1,
  color2,
  color3,
  color4,
  color5,
];

// RESERVATION TEXT

const kReservationText = TextStyle(fontSize: 26.0);
