import 'package:flutter/material.dart';

const kWelcomeScreenTitle = TextStyle(
  fontSize: 42.0,
  fontFamily: 'Rubik Marker Hatch',
);

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
