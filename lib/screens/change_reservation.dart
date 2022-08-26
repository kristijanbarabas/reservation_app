import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:reservation_app/components/text_field_widget.dart';
import 'package:reservation_app/components/rounded_button.dart';
import 'package:reservation_app/constants.dart';

import 'package:reservation_app/screens/main_menu_screen.dart';
import 'package:reservation_app/screens/welcome_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

final _firestore = FirebaseFirestore.instance;

late User loggedInUser;

class ChangeReservation extends StatefulWidget {
  static const String id = 'reservation_details';

  const ChangeReservation({Key? key}) : super(key: key);

  @override
  State<ChangeReservation> createState() => _ChangeReservationState();
}

class _ChangeReservationState extends State<ChangeReservation> {
  // bool
  bool isLoading = true;
  // FORM DATA
  late String name = fireData['name'];
  late String lastName = fireData['lastname'];
  late Timestamp timestamp = fireData['timestamp'];
  late DateTime reservationDate = timestamp.toDate();
  late String reservationTime = fireData['time'];

  //firebase authentication
  final _auth = FirebaseAuth.instance;
  //text field editing controller
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();

  getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      Alert(context: context, title: "Error", desc: "Try again!").show();
    }
  }

  late Map<String, dynamic> fireData = {};

  getData() async {
    isLoading = true;
    final docRef = _firestore
        .collection('reservation')
        .where('sender', isEqualTo: loggedInUser.email)
        .get();
    await docRef.then(
      (QuerySnapshot snapshot) {
        final data = snapshot.docs.forEach((DocumentSnapshot doc) {
          setState(() {
            fireData = doc.data() as Map<String, dynamic>;
            isLoading = false;
          });
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  updateData() async {
    final docRef = _firestore
        .collection('reservation')
        .where('sender', isEqualTo: loggedInUser.email)
        .get();
    await docRef.then((querySnapshot) => {
          querySnapshot.docs[0].reference.set({
            'name': name,
            'lastname': lastName,
            'timestamp': reservationDate,
            'time': reservationTime,
            'sender': loggedInUser.email
          })
        });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getData();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.

    _controller1.dispose();

    _controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          GestureDetector(
            onTap: () {
              _auth.signOut();
              Navigator.pushNamed(context, WelcomeScreen.id);
            },
            child: const Icon(Icons.clear),
          ),
        ],
        title: const Text('Change Reservation'),
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? const SpinKitChasingDots(
              color: Colors.black,
              duration: Duration(seconds: 3),
            )
          : Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () async {
                          DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: reservationDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2023),
                            selectableDayPredicate: (DateTime day) =>
                                day.weekday == 6 || day.weekday == 7
                                    ? false
                                    : true,
                          );
                          setState(() {
                            reservationDate = newDate!;
                          });
                        },
                        child: Text(
                          'Date: ${reservationDate.day}/${reservationDate.month}/${reservationDate.year}',
                          style: const TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),

                    // RESERVATION TIME
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
                            print(reservationTime);
                          });
                        }),

// UPDATE BUTTON
                    RoundedButton(
                      iconData: Icons.done,
                      googleFonts: kGoogleFonts,
                      color: Colors.purple,
                      title: 'Change Reservation',
                      onPressed: () {
                        updateData();
                        Navigator.pushNamed(context, MainMenu.id);
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
