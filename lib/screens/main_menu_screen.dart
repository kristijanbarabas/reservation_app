import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reservation_app/components/reservation_details.dart';
import 'package:reservation_app/constants.dart';
import 'package:reservation_app/screens/reservation_details_screen.dart';
import 'package:reservation_app/screens/welcome_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

final _firestore = FirebaseFirestore.instance;

late User loggedInUser;

class MainMenu extends StatefulWidget {
  static const String id = 'menu_screen';
  late String? username;
  final String userID;
  final String? imageUrl;

  MainMenu({
    Key? key,
    required this.username,
    required this.userID,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  bool isLoading = true;

  late Map<String, dynamic> firebaseData = {};

  // authentification
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
    isLoading = false;
  }

  signoutUser() {
    try {
      _auth.signOut();
      print('Signout Succesfull');
    } catch (e) {
      print('Signout Failed');
    }
  }

  void deleteReservationOnPressed(String bookingEnd) async {
    final docRef = _firestore
        .collection('user')
        .doc('reservation')
        .collection('reservation')
        .where('bookingEnd', isEqualTo: bookingEnd)
        .get();
    await docRef.then(
      (querySnapshot) {
        querySnapshot.docs.forEach(
          (doc) {
            doc.reference.delete();
          },
        );
      },
    );
  }

  /*  void deleteData(int index) async {
    final docRef = _firestore
        .collection('user')
        .doc('reservation')
        .collection('reservation')
        .where('userId', isEqualTo: loggedInUser.uid)
        .get();
    await docRef.then((QuerySnapshot querySnapshot) =>
        {querySnapshot.docs[index].reference.delete()});
  } */

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const SpinKitChasingDots(
            color: Colors.black,
            duration: Duration(seconds: 3),
          )
        : Scaffold(
            backgroundColor: kBackgroundColor,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: kButtonColor,
              leading: CircleAvatar(
                backgroundColor: kButtonColor,
                radius: 100.0,
                child: widget.imageUrl == ''
                    ? const FaIcon(FontAwesomeIcons.faceGrin,
                        size: 40, color: Colors.white)
                    : ClipOval(
                        child: Image.network(widget.imageUrl!,
                            height: 50, width: 50, fit: BoxFit.cover),
                      ),
              ),
              title: Text(
                'Welcome ${widget.username} !',
                style: kGoogleFonts,
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    Alert(
                      context: context,
                      type: AlertType.warning,
                      title: "SIGN OUT!",
                      desc: "Are you sure?",
                      buttons: [
                        DialogButton(
                          onPressed: () {
                            signoutUser();
                            Navigator.pushNamed(context, WelcomeScreen.id);
                          },
                          color: kButtonColor,
                          child: const Text(
                            "YES",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        DialogButton(
                          onPressed: () => Navigator.pop(context),
                          color: kButtonColor,
                          child: const Text(
                            "NO",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )
                      ],
                    ).show();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 15.0, right: 10.0),
                    child: FaIcon(FontAwesomeIcons.rightFromBracket),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Your Reservations:',
                        style: kGoogleFonts.copyWith(fontSize: 40.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: StreamBuilder<QuerySnapshot>(
                          stream: _firestore
                              .collection('user')
                              .doc('reservation')
                              .collection('reservation')
                              .where('userId', isEqualTo: loggedInUser.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: SpinKitChasingDots(
                                  color: Colors.black,
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            } else {
                              final reservation = snapshot.data!.docs;

                              // list of widgets
                              List<ReservationDetails> reservationList = [];
                              //
                              for (var snapshot in reservation) {
                                Map<String, dynamic> fireData =
                                    snapshot.data() as Map<String, dynamic>;
                                final String bookingStart =
                                    fireData['bookingStart'];
                                final DateTime parsedReservationStart =
                                    DateTime.parse(bookingStart);
                                final bookingEnd = fireData['bookingEnd'];
                                final DateTime parsedReservationEnd =
                                    DateTime.parse(bookingEnd);
                                final String sortReservationDate =
                                    '${parsedReservationEnd.day}.${parsedReservationEnd.month}.${parsedReservationEnd.year}';

                                final reservationWidget = ReservationDetails(
                                  date: parsedReservationEnd,
                                  reservationEnd: bookingEnd,
                                  reservationTime:
                                      '${parsedReservationStart.hour}:00 - ${parsedReservationEnd.hour}:00',
                                  reservationDate: sortReservationDate,
                                );

                                reservationList.add(reservationWidget);

                                reservationList
                                    .sort((a, b) => a.date.compareTo(b.date));
                              }
                              return Row(
                                children: [
                                  Expanded(
                                      child: ListView.builder(
                                    itemCount: reservationList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                          // ROUTE TO RESERVATION SCREEN DETAILS
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: ((context) =>
                                                    ReservationScreen(
                                                      reservationDate:
                                                          reservationList[index]
                                                              .reservationDate,
                                                      reservationTime:
                                                          reservationList[index]
                                                              .reservationTime,
                                                    )),
                                              ),
                                            );
                                          },
                                          // DELETE FUNCTION
                                          onDoubleTap: () {
                                            print(reservationList[index]
                                                .reservationEnd);
                                          },
                                          onLongPress: () {
                                            Alert(
                                              context: context,
                                              type: AlertType.warning,
                                              title: "DELETE RESERVATION!",
                                              desc: "Are you sure?",
                                              buttons: [
                                                DialogButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    deleteReservationOnPressed(
                                                        reservationList[index]
                                                            .reservationEnd);
                                                  },
                                                  color: kButtonColor,
                                                  child: const Text(
                                                    "YES",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                                DialogButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  color: kButtonColor,
                                                  child: const Text(
                                                    "NO",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                )
                                              ],
                                            ).show();
                                          },
                                          child: reservationList[index]);
                                    },
                                  )),
                                ],
                              );
                            }
                          }),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  )
                ],
              ),
            ),
          );
  }
}


/*   updateData() async {
    final docRef = _firestore
        .collection('reservation')
        .where('sender', isEqualTo: loggedInUser.email)
        .get();
    await docRef.then((querySnapshot) => {
          querySnapshot.docs[0].reference.set({
            'name': username,
            'timestamp': reservationDate,
            'time': reservationTime,
            'sender': loggedInUser.email
          })
        });
  } */

