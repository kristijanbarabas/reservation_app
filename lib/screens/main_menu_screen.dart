import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:reservation_app/components/reservation_details.dart';
import 'package:reservation_app/components/rounded_button.dart';
import 'package:reservation_app/constants.dart';
import 'package:reservation_app/screens/welcome_screen.dart';
import 'package:reservation_app/components/bottom_sheet.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

final _firestore = FirebaseFirestore.instance;

late User loggedInUser;

class MainMenu extends StatefulWidget {
  static const String id = 'menu_screen';
  final String userID;
  const MainMenu({Key? key, required this.userID}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  bool isLoading = true;
  // PROFILE DATA
  late Map<String, dynamic> fireProfile = {};
  late String username = fireProfile['username'];
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
  }

  signoutUser() {
    try {
      _auth.signOut();
      print('Signout Succesfull');
    } catch (e) {
      print('Signout Failed');
    }
  }

  getProfile() async {
    isLoading = true;
    final docRef = _firestore
        .collection('user')
        .doc(loggedInUser.uid)
        .collection('profile')
        .get();
    await docRef.then(
      (QuerySnapshot snapshot) {
        final data = snapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
          setState(() {
            fireProfile = documentSnapshot.data() as Map<String, dynamic>;
            isLoading = false;
          });
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  void deleteData(int index) async {
    final docRef = _firestore
        .collection('user')
        .doc(loggedInUser.uid)
        .collection('reservation')
        .get();
    await docRef.then(
        (querySnapshot) => {querySnapshot.docs[index].reference.delete()});
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getProfile();
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
              title: Text(
                'Welcome $username !',
                style: kGoogleFonts,
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    signoutUser();
                    Navigator.pushNamed(context, WelcomeScreen.id);
                  },
                  child: const Icon(Icons.clear),
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
                      child: isLoading
                          ? const SpinKitChasingDots(
                              color: Colors.black,
                              duration: Duration(seconds: 3),
                            )
                          : StreamBuilder<QuerySnapshot>(
                              stream: _firestore
                                  .collection('user')
                                  .doc(loggedInUser.uid)
                                  .collection('reservation')
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
                                    final String reservationTime =
                                        fireData['bookingStart'];
                                    final DateTime parsedReservationTime =
                                        DateTime.parse(reservationTime);
                                    final reservationDate =
                                        fireData['bookingEnd'];
                                    final DateTime parsedReservationDate =
                                        DateTime.parse(reservationDate);
                                    final sortReservationDate =
                                        parsedReservationDate.day.toString();

                                    final reservationWidget =
                                        ReservationDetails(
                                      reservationTime:
                                          '${parsedReservationTime.hour}:00 - ${parsedReservationDate.hour}:00',
                                      reservationDate:
                                          '${parsedReservationDate.day}.${parsedReservationDate.month}.${parsedReservationDate.year}',
                                    );

                                    reservationList.add(reservationWidget);
                                    reservationList.sort(((a, b) => a
                                        .reservationTime
                                        .compareTo(b.reservationTime)));
                                  }
                                  return Row(
                                    children: [
                                      Expanded(
                                          child: ListView.builder(
                                        itemCount: reservationList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () => print(
                                                index), //here you have access to it
                                            child: GestureDetector(
                                                onLongPress: () {
                                                  Alert(
                                                    context: context,
                                                    type: AlertType.warning,
                                                    title:
                                                        "DELETE RESERVATION!",
                                                    desc: "Are you sure?",
                                                    buttons: [
                                                      DialogButton(
                                                        child: Text(
                                                          "YES",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          deleteData(index);
                                                        },
                                                        color: Color.fromRGBO(
                                                            0, 179, 134, 1.0),
                                                      ),
                                                      DialogButton(
                                                        child: Text(
                                                          "NO",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 20),
                                                        ),
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        gradient:
                                                            LinearGradient(
                                                                colors: [
                                                              Color.fromRGBO(
                                                                  116,
                                                                  116,
                                                                  191,
                                                                  1.0),
                                                              Color.fromRGBO(52,
                                                                  138, 199, 1.0)
                                                            ]),
                                                      )
                                                    ],
                                                  ).show();
                                                },
                                                child: reservationList[index]),
                                          );
                                        },
                                      )),
                                    ],
                                  );
                                }
                              }),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: RoundedButton(
                            iconData: Icons.add,
                            color: kButtonColor,
                            title: 'Add',
                            onPressed: () {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) =>
                                      const CustomBottomSheet());
                            },
                            googleFonts: kMainMenuFonts),
                      ),
                      SizedBox(
                        width: 14.0,
                      ),
                      Expanded(
                        child: RoundedButton(
                          iconData: Icons.edit,
                          googleFonts: kMainMenuFonts,
                          color: kButtonColor,
                          title: 'Edit',
                          onPressed: () {},
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
  }
}

  /* getReservation() async {
    isLoading = true;
    final docRef = await _firestore
        .collection('user')
        .doc(loggedInUser.uid)
        .collection('reservation')
        .get();
    /*  await docRef.then(
      (QuerySnapshot snapshot) {
        final data = snapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
          setState(() {
            fireData = documentSnapshot.data() as Map<String, dynamic>;
            isLoading = false;
          });
        });
      },  */
    for (var snapshot in docRef.docs) {
      final data = snapshot.data();
      print(data);
      fireList.add(data);
    }
    /*  onError: (e) => print("Error getting document: $e"),
    ); */
  } */

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