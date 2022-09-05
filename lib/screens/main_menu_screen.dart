import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:reservation_app/components/reservation_details.dart';
import 'package:reservation_app/components/rounded_button.dart';
import 'package:reservation_app/constants.dart';
import 'package:reservation_app/screens/welcome_screen.dart';
import 'package:reservation_app/components/bottom_sheet.dart';

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
  // RESERVATION DATA
  /*  late int index;
  List fireList = [];
  late Timestamp timestamp = fireList[index]['timestamp'];
  late DateTime reservationDate = timestamp.toDate();
  late String reservationTime = fireList[index]['time']; */
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

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    //getReservation();
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
              backgroundColor: kButtonColor,
              title: Text(
                'Welcome $username !',
                style: kGoogleFonts,
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    _auth.signOut();
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
                                                onDoubleTap: () {
                                                  deleteData(index);
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
