import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const kWelcomeScreenTitle = TextStyle(
  fontSize: 42.0,
  fontFamily: 'Rubik Marker Hatch',
);

// BUTTON FONT AND STYLE
final TextStyle kGoogleFonts = GoogleFonts.lora(
    textStyle: const TextStyle(
        fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.w700));

// button titles
const String kLoginTitle = 'Log in';
const String kRegisterTitle = 'Register';
const String kSubmit = 'Submit';

const kTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

// reservation details screen

const TextStyle kReservationDetails =
    TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500);

// dropdownbutton list

List<String> dropdownButtonList = [
  '8:00 - 10:00',
  '10:00 - 12:00',
  '12:00 - 14:00',
  '14:00 - 16:00',
];

// title colors
const Color color1 = Color(0xff878986);
const Color color2 = Color.fromARGB(255, 86, 97, 12);
const Color color3 = Color.fromARGB(255, 20, 158, 61);
const Color color4 = Color.fromARGB(255, 73, 66, 5);
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
