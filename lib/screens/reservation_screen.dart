import 'package:flutter/material.dart';

import 'package:reservation_app/components/text_field_widget.dart';
import 'package:reservation_app/constants.dart';

import 'package:reservation_app/screens/main_menu_screen.dart';
import 'package:reservation_app/screens/welcome_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//firestore instance
final _firestore = FirebaseFirestore.instance;

class ReservationScreen extends StatefulWidget {
  static const String id = 'reservation_screen';

  const ReservationScreen({Key? key}) : super(key: key);

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  // firebase auth
  final _auth = FirebaseAuth.instance;
  // creating our user
  late User registeredUser;

  // FORM variables
  late String name;
  late String lastName;
  late Timestamp timestamp = Timestamp.fromDate(date);
  // drop down button value for time
  late String reservationTime = dropdownButtonList[0];

  // DATE
  DateTime date = DateTime.now();

  // controlleri
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();

  // method to check if the user is signed in
  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        registeredUser = user;
        print(registeredUser.email);
      }
    } catch (e) {
      Alert(context: context, title: "Error", desc: "Try again!").show();
    }
  }

  @override
  void initState() {
    super.initState();
    // initialize the method in the inital state of the app
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kButtonColor,
        title: const Text('Reservation'),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, WelcomeScreen.id);
            },
            child: const Icon(Icons.clear),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                'Make your reservation!',
                style: kGoogleFonts.copyWith(fontSize: 30.0),
              ),
            ),
            const SizedBox(
              height: 18.0,
            ),
            TextFieldWidget(
              controller: _controller1,
              newValue: (value) {
                name = value!;
              },
              labelText: 'Name:',
              hintText: 'Enter your name...',
            ),
            const SizedBox(
              height: 18.0,
            ),
            TextFieldWidget(
              controller: _controller2,
              newValue: (value) {
                lastName = value!;
              },
              labelText: 'Last Name:',
              hintText: 'Enter your last name...',
            ),
            const SizedBox(
              height: 18.0,
            ),
            // IMPLEMENT DATE PICKER
            Container(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () async {
                  DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2023),
                    selectableDayPredicate: (DateTime day) =>
                        day.weekday == 6 || day.weekday == 7 ? false : true,
                  );
                  setState(() {
                    date = newDate!;
                  });
                },
                child: Text(
                  'Date: ${date.day}/${date.month}/${date.year}',
                  style: kGoogleFonts,
                ),
              ),
            ),

            const SizedBox(
              height: 8.0,
            ),

            // IMPLEMENT DROPDOWN BUTTON
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton(
                    dropdownColor: kBackgroundColor,
                    value: reservationTime,
                    icon: const Icon(
                      Icons.arrow_downward,
                      color: kButtonColor,
                    ),
                    elevation: 20,
                    style: kGoogleFonts,
                    items: dropdownButtonList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Container(
                            color: kBackgroundColor,
                            child: Text(
                              value,
                              style: const TextStyle(fontSize: 20.0),
                            )),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        reservationTime = newValue!;
                      });
                    }),
              ],
            ),

            // SUBMIT BUTTON
            RoundedButton(
              iconData: Icons.check,
              googleFonts: kGoogleFonts,
              color: kButtonColor,
              title: kSubmit,
              onPressed: () {
                _firestore.collection('reservation').add({
                  'name': name,
                  'lastname': lastName,
                  'timestamp': timestamp,
                  'time': reservationTime,
                  'sender': registeredUser.email,
                });
                Navigator.pushNamed(context, MainMenu.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
