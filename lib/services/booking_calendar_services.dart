import 'package:booking_calendar/booking_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservation_app/services/firestore_database.dart';
import 'package:reservation_app/services/firestore_path.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../models/reservation_data.dart';
import '../models/reservations.dart';

class BookingCalendarServices {
  //TODO create a stream provider
  final _firestore = FirebaseFirestore.instance;

  ///This is how can you get the reference to your data from the collection, and serialize the data with the help of the Firestore [withConverter]. This function would be in your repository.
  CollectionReference<ReservationData> getBookingStream(
      {required String placeId}) {
    CollectionReference reservationBookingStream =
        _firestore.collection('user');
    return reservationBookingStream
        .doc(placeId)
        .collection('reservation')
        .withConverter<ReservationData>(
          fromFirestore: (snapshots, _) =>
              ReservationData.fromJson(snapshots.data()!),
          toFirestore: (snapshots, _) => snapshots.toJson(),
        );
  }

  ///How you actually get the stream of data from Firestore with the help of the previous function
  ///note that this query filters are for my data structure, you need to adjust it to your solution.
  Stream<QuerySnapshot<ReservationData>>? getBookingStreamFirebase(
      {required DateTime end, required DateTime start}) {
    return getBookingStream(placeId: 'reservation')
        .where('bookingStart', isGreaterThanOrEqualTo: start)
        .where('bookingStart', isLessThanOrEqualTo: end)
        .snapshots();
  }

  Future<dynamic> uploadBooking(
    BuildContext context, {
    required BookingService newBooking,
  }) async {
    await FirestorePath.userReservationsPath()
        .add(newBooking.toJson())
        .whenComplete(() {
      Alert(
        context: context,
        type: AlertType.success,
        title: "SUCCESS!",
        desc: "Your reservation has been added.",
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.pop(context);
            },
            width: 120,
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ).show();
    }).catchError((error) {
      Alert(
        context: context,
        type: AlertType.error,
        title: "ERROR!",
        desc: "Something went wrong! Try again!",
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.pop(context);
            },
            width: 120,
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ).show();
    });
  }

  DateTime dateNow = DateTime.now();
  late DateTime startDate =
      DateTime(dateNow.year, dateNow.month, dateNow.day, 0);
  late DateTime endDate =
      DateTime(dateNow.year, dateNow.month, dateNow.day, 24);

  // Generated pause slots so the user can't pick a appointment that has passed - grey color
  List<DateTimeRange> generatePauseSlots() {
    List<DateTimeRange> dateTimeRangeList = [];
    if (startDate.weekday != DateTime.saturday &&
        startDate.weekday != DateTime.sunday) {
      dateTimeRangeList
          .add(DateTimeRange(start: startDate, end: DateTime.now()));
    } else if (startDate.weekday == DateTime.saturday ||
        startDate.weekday == DateTime.sunday) {
      dateTimeRangeList.add(DateTimeRange(start: startDate, end: endDate));
    }
    return dateTimeRangeList;
  }

  late DateTimeRange reservationWidget;
  List<DateTimeRange> convertedDateTimeRange = [];
  // List of booked appontiments required by the package
  List<DateTimeRange> convertedStreamResult({required dynamic streamResult}) {
    final stream = FirestorePath.userReservationsPath().snapshots();
    stream.listen((querySnapshot) {
      final allReservations = querySnapshot.docs;
      for (var reservation in allReservations) {
        late Map<String, dynamic> fireData =
            reservation.data() as Map<String, dynamic>;
        final reservations = Reservations.fromMap(fireData);
        final String reservationTime = reservations.bookingStart!;
        final DateTime parsedReservationTime = DateTime.parse(reservationTime);
        final reservationDate = reservations.bookingEnd!;
        final DateTime parsedReservationDate = DateTime.parse(reservationDate);
        reservationWidget = DateTimeRange(
            start: parsedReservationTime, end: parsedReservationDate);
        convertedDateTimeRange.add(reservationWidget);
      }
    });
    return convertedDateTimeRange;
  }
}

final bookingCalendarServices =
    Provider.autoDispose<BookingCalendarServices?>((ref) {
  final auth = ref.watch(authStateChangesProvider);
  if (auth.asData?.value?.uid != null) {
    return BookingCalendarServices();
  } else {
    return null;
  }
});
