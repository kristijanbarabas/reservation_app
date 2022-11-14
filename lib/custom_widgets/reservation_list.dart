import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservation_app/custom_widgets/async_value_widget.dart';
import 'package:reservation_app/custom_widgets/reservation_details.dart';
import '../services/firestore_database.dart';

class ReservationList extends StatelessWidget {
  const ReservationList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: ((context, ref, child) {
        final firestoreDatabase = ref.watch(databaseProvider);
        final reservationsList = ref.watch(userReservationProvider);
        return AsyncValueWidget<List<ReservationDetails>>(
          value: reservationsList,
          data: (userReservations) {
            return ListView.builder(
                itemCount: userReservations.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    // Route to reservation details screen
                    onTap: () {
                      /*  Navigator.push(
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
                                        ); */
                    },
                    // Delete function
                    child: Dismissible(
                      key: ValueKey(userReservations[index]),
                      onDismissed: ((direction) {
                        firestoreDatabase!.deleteReservationOnSwipe(
                            bookingEnd: userReservations[index].bookingEnd);
                      }),
                      child: userReservations[index],
                    ),
                  );
                });
          },
        );
      }),
    );
  }
}
