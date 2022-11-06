import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservation_app/custom_widgets/app_bar_username.dart';
import 'package:reservation_app/custom_widgets/reservation_details.dart';
import 'package:reservation_app/custom_widgets/sign_out_button.dart';
import 'package:reservation_app/services/constants.dart';
import 'package:reservation_app/screens/reservation_details_screen.dart';
import 'package:reservation_app/services/firestore_database.dart';
import '../custom_widgets/app_bar_profile_picture.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainMenu extends ConsumerWidget {
  static const String id = 'menu_screen';

  const MainMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final auth = FirebaseAuth.instance;
    final firestoreDatabase = ref.watch(databaseProvider);
    // Firestore
    final firestore = FirebaseFirestore.instance;
    // Stream
    late Stream<QuerySnapshot<Object?>>? reservationStream = firestore
        .collection('user')
        .doc('reservation')
        .collection('reservation')
        .where('userId', isEqualTo: auth.currentUser?.uid)
        .snapshots();

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kButtonColor,
        leading: const CircleAvatar(
            backgroundColor: kButtonColor,
            radius: 100.0,
            // Profile picture
            child: AppBarProfilePictureWidget()),
        // Username
        title: const AppBarUsernameWidget(),
        actions: const [
          SignOutButton(),
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
                            bookingEnd: bookingEnd,
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
                                  // Route to reservation details screen
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
                                  // Delete function
                                  child: Dismissible(
                                    key: ValueKey(reservationList[index]),
                                    onDismissed: ((direction) {
                                      firestoreDatabase!
                                          .deleteReservationOnSwipe(
                                              reservationList[index]
                                                  .bookingEnd);
                                    }),
                                    child: reservationList[index],
                                  ),
                                );
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
