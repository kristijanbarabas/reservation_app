import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:reservation_app/components/rounded_button.dart';
import 'package:reservation_app/constants.dart';
import 'package:reservation_app/screens/change_reservation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reservation_app/components/reservation_text.dart';

final _firestore = FirebaseFirestore.instance;

late User loggedInUser;

class MainMenu extends StatefulWidget {
  static const String id = 'menu_screen';
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  bool isLoading = true;
  late Map<String, dynamic> fireData = {};
  late String name = fireData['name'];
  late String lastName = fireData['lastname'];
  late Timestamp timestamp = fireData['timestamp'];
  late DateTime reservationDate = timestamp.toDate();
  late String reservationTime = fireData['time'];
  final _auth = FirebaseAuth.instance;

  getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

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

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Main Menu'),
          ),
          body: isLoading
              ? const SpinKitChasingDots(
                  color: Colors.black,
                  duration: Duration(seconds: 3),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          child: const Text(
                            'Reservation Details',
                            style: TextStyle(fontSize: 30.0),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ReservationText(label: 'Name', value: name),
                              ReservationText(
                                label: 'Last Name',
                                value: lastName,
                              ),
                              ReservationText(
                                label: 'Reservation Date',
                                value:
                                    '${reservationDate.day}.${reservationDate.month}.${reservationDate.year}',
                              ),
                              ReservationText(
                                label: 'Reservation Time',
                                value: reservationTime,
                              ),
                            ],
                          ),
                        ),
                      ),
                      RoundedButton(
                          color: Colors.red,
                          title: 'Change Reservation',
                          onPressed: () {
                            Navigator.pushNamed(context, ChangeReservation.id);
                          },
                          googleFonts: kGoogleFonts)
                    ],
                  ),
                ),
        );
      },
      stream: _firestore
          .collection('reservation')
          .where('sender', isEqualTo: loggedInUser.email)
          .snapshots(),
    );
  }
}
