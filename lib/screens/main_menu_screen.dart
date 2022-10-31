import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reservation_app/custom_widgets/empty_placeholder_widget.dart';
import 'package:reservation_app/custom_widgets/reservation_details.dart';
import 'package:reservation_app/services/constants.dart';
import 'package:reservation_app/screens/reservation_details_screen.dart';
import 'package:reservation_app/screens/welcome_screen.dart';
import 'package:reservation_app/services/firestore_database.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../custom_widgets/profile_picture_widget.dart';

final _firestore = FirebaseFirestore.instance;

class MainMenu extends ConsumerWidget {
  static const String id = 'menu_screen';

  MainMenu({
    Key? key,
  }) : super(key: key);

  // FIREBASE DATA
  late Map<String, dynamic> firebaseData = {};
  // AUTHENTIFICATION
  final _auth = FirebaseAuth.instance;
  // STREAM
  late Stream<QuerySnapshot<Object?>>? reservationStream = _firestore
      .collection('user')
      .doc('reservation')
      .collection('reservation')
      .where('userId', isEqualTo: _auth.currentUser!.uid)
      .snapshots();

  signoutUser() {
    try {
      _auth.signOut();
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

  late Text textWidget;
  late Widget profilePictureWidget;

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kButtonColor,
        leading: CircleAvatar(
            backgroundColor: kButtonColor,
            radius: 100.0,
            // Profile picture
            child: Consumer(
              builder: (context, ref, child) {
                final userProfileAsyncValue =
                    ref.watch(userProfileProvider(_auth.currentUser?.uid));
                return userProfileAsyncValue.when(
                  data: (userProfile) {
                    userProfile.userProfilePicture == null
                        ? profilePictureWidget = const FaIcon(
                            FontAwesomeIcons.faceGrin,
                            size: 40,
                            color: Colors.white)
                        : profilePictureWidget = ProfilePictureWidget(
                            profilePicture: userProfile.userProfilePicture!,
                            imageHeight: 50,
                            imageWidth: 50,
                          );
                    return profilePictureWidget;
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stackTrace) {
                    return const EmptyPlaceholderWidget();
                  },
                );
              },
            )),
        // Username
        title: Consumer(builder: (context, ref, child) {
          final userProfileAsyncValue =
              ref.watch(userProfileProvider(_auth.currentUser?.uid));
          return userProfileAsyncValue.when(
              data: (userProfile) {
                return userProfile.username == null
                    ? const Text('Welcome!')
                    : Text('Welcome ${userProfile.username}!');
              },
              loading: () => const CircularProgressIndicator(),
              error: (error, stackTrace) {
                return const EmptyPlaceholderWidget();
              });
        }),
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
                    stream: reservationStream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Text('');
                      } else {
                        final reservation = snapshot.data!.docs;
                        // list of widgets
                        List<ReservationDetails> reservationList = [];
                        //
                        for (var snapshot in reservation) {
                          Map<String, dynamic> fireData =
                              snapshot.data() as Map<String, dynamic>;
                          final String bookingStart = fireData['bookingStart'];
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
                              itemBuilder: (BuildContext context, int index) {
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
