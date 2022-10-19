import 'package:flutter/material.dart';
import 'package:reservation_app/constants.dart';
import 'package:reservation_app/screens/main_menu_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//firestore instance
final _firestore = FirebaseFirestore.instance;

class ReservationScreen extends StatefulWidget {
  static const String id = 'reservation_screen';
  final String reservationDate;
  final String reservationTime;

  const ReservationScreen(
      {Key? key, required this.reservationDate, required this.reservationTime})
      : super(key: key);

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  bool isLoading = true;
  getReservation(index) async {
    isLoading = true;
    final docRef = _firestore
        .collection('user')
        .doc(loggedInUser.uid)
        .collection('profile')
        .get();
    await docRef.then(
      (QuerySnapshot snapshot) {
        snapshot.docs[index].reference.delete();
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  // firebase auth
  final _auth = FirebaseAuth.instance;
  // creating our user
  late User registeredUser;

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
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          backgroundColor: kButtonColor,
          title: const Text('Reservation Details'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Reservation Date:\n${widget.reservationDate}',
                style: kMainMenuFonts,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Reservation Time:\n${widget.reservationTime}',
                style: kMainMenuFonts,
              )
            ],
          ),
        ));
  }
}
