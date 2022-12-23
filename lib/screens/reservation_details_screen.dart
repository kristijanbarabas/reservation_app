import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservation_app/custom_widgets/async_value_widget.dart';
import 'package:reservation_app/models/user_profile.dart';
import 'package:reservation_app/services/constants.dart';

import '../services/authentication.dart';
import '../services/firestore_database.dart';

class ReservationDetailsScreen extends StatelessWidget {
  const ReservationDetailsScreen(
      {super.key,
      required this.reservationDate,
      required this.reservationTime});
  static const String id = 'reservation_screen';
  final String reservationDate;
  final String reservationTime;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer(builder: ((context, ref, child) {
                final loggedInUserUid = ref.watch(loggedInUserUidProvider);
                final userProfileAsyncValue =
                    ref.watch(userProfileProvider(loggedInUserUid));
                return AsyncValueWidget<UserProfile>(
                  value: userProfileAsyncValue,
                  data: (userProfile) {
                    return Column(children: [
                      Text(
                        'First Name:\n${userProfile.firstName}',
                        style: kMainMenuFonts,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Last Name:\n${userProfile.lastName}',
                        style: kMainMenuFonts,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ]);
                  },
                );
              })),
              Text(
                'Reservation Date:\n$reservationDate',
                style: kMainMenuFonts,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Reservation Time:\n$reservationTime',
                style: kMainMenuFonts,
              )
            ],
          ),
        ));
  }
}
