import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// BUTTON FONT AND STYLE
final TextStyle kGoogleFonts = GoogleFonts.rancho(
  textStyle: const TextStyle(
      fontSize: 22.0,
      color: Colors.white,
      fontWeight: FontWeight.w700,
      letterSpacing: 2.0),
);
final TextStyle kMainMenuFonts = GoogleFonts.roboto(
  textStyle: const TextStyle(
      fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.w700),
);

final TextStyle kTextFieldInputStyle = GoogleFonts.roboto(
  textStyle: const TextStyle(
      fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.w700),
);
// COLORS

const Color kBackgroundColor = Color(0xff363835);
const Color kButtonColor = Color(0xff415A30);
const Color kModalSheetRadiusColor = Color(0xff191a18);

// BUTTON TITLES
const String kLoginTitle = 'Sign in';
const String kRegisterTitle = 'Register';
const String kSubmit = 'Submit';
const String kEditProfile = 'Edit Profile';
// TEXT FIELD DECORATION

var kTextFieldDecoration = InputDecoration(
  hintStyle: GoogleFonts.roboto(
    color: Colors.white.withOpacity(0.5),
  ),
  labelStyle: GoogleFonts.roboto(
    color: Colors.white.withOpacity(0.5),
  ),
  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: kButtonColor, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: kButtonColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

// GOOGLE LOG-ING TEXT
TextStyle kGoogleLoginStyle = GoogleFonts.roboto(
    fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.w500);

// RESERVATION DETAILS SCREEN

TextStyle kReservationDetails = GoogleFonts.roboto(
    fontSize: 20.0, fontWeight: FontWeight.w500, color: Colors.white);

// dropdownbutton list

// RESERVATION TEXT

const kReservationText = TextStyle(fontSize: 26.0);
