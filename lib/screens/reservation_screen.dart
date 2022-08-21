import 'package:flutter/material.dart';
import 'package:reservation_app/constants.dart';
import 'package:reservation_app/screens/reservation_details_screen.dart';
import 'package:reservation_app/screens/welcome_screen.dart';
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

  // method to check if the user is signed in
  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        registeredUser = user;
        print(registeredUser.email);
      }
    } catch (e) {
      print(e);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
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
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Make your reservation!',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            const SizedBox(
              height: 18.0,
            ),
            TextField(
              decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Enter your name...'),
              onChanged: (value) {
                name = value;
              },
            ),
            const SizedBox(
              height: 18.0,
            ),
            TextField(
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your last name...'),
              onChanged: (value) {
                lastName = value;
              },
            ),
            const SizedBox(
              height: 18.0,
            ),
            // IMPLEMENT DATE PICKER
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () async {
                  DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2023),
                    /* selectableDayPredicate: (DateTime day) =>
                        day.weekday == 6 || day.weekday == 7 ? false : true, */
                  );
                  setState(() {
                    date = newDate!;
                  });
                },
                child: Text(
                  'Date: ${date.day}/${date.month}/${date.year}',
                  style: const TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            Divider(
              color: Colors.purple,
            ),
            const SizedBox(
              height: 8.0,
            ),

            // IMPLEMENT DROPDOWN BUTTON
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton(
                    value: reservationTime,
                    icon: const Icon(
                      Icons.arrow_downward,
                      color: Colors.purple,
                    ),
                    elevation: 16,
                    style: const TextStyle(color: Colors.purple),
                    underline: Container(
                      color: Colors.transparent,
                    ),
                    items: dropdownButtonList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Container(
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
            const Divider(
              color: Colors.purple,
            ),
            const SizedBox(),
            // SUBMIT BUTTON
            RoundedButton(
                color: Colors.purple,
                title: kSubmit,
                onPressed: () {
                  _firestore.collection('reservation').add({
                    'name': name,
                    'lastname': lastName,
                    'timestamp': timestamp,
                    'time': reservationTime,
                    'sender': registeredUser.email,
                  });
                  Navigator.pushNamed(context, ReservationDetails.id);
                }),
          ],
        ),
      ),
    );
  }
}
