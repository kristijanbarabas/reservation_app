import 'package:flutter/material.dart';
import 'package:reservation_app/services/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
  //firestore instance
  final _firestore = FirebaseFirestore.instance;
  //loading bool
  bool isLoading = true;
  //
  void getReservation(index) async {
    isLoading = true;
    final docRef = _firestore
        .collection('user')
        .doc(getCurrentUser()!.uid)
        .collection('profile')
        .get();
    await docRef.then(
      (QuerySnapshot snapshot) {
        snapshot.docs[index].reference.delete();
      },
      onError: (e) =>
          Alert(context: context, title: "Error", desc: "Try again!").show(),
    );
  }

  // firebase auth
  final _auth = FirebaseAuth.instance;

  // method to check if the user is signed in
  User? getCurrentUser() {
    late User loggedInUser;
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      Alert(context: context, title: "Error", desc: "Try again!").show();
    }
    isLoading = false;
    return loggedInUser;
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
