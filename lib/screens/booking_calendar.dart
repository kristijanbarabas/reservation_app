import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reservation_app/custom_widgets/loading_widget.dart';
import 'package:reservation_app/data.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'package:reservation_app/services/constants.dart';
//import 'package:collection/collection.dart';

// creating our user
late User loggedInUser;
//firestore instance
final _firestore = FirebaseFirestore.instance;
// DATE
DateTime date = DateTime.now();
CollectionReference reservationBookingStream = _firestore.collection('user');
CollectionReference reservation =
    _firestore.collection('user').doc('reservation').collection('reservation');

class CustomBookingCalendar extends StatefulWidget {
  static const String id = 'custom_booking_calendar';
  const CustomBookingCalendar({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomBookingCalendar> createState() => _CustomBookingCalendarState();
}

class _CustomBookingCalendarState extends State<CustomBookingCalendar> {
  // firebase auth
  final _auth = FirebaseAuth.instance;

  // bool
  bool isLoading = false;

  // booking service
  late BookingService reservationService;

  ///This is how can you get the reference to your data from the collection, and serialize the data with the help of the Firestore [withConverter]. This function would be in your repository.
  CollectionReference<Data> getBookingStream({required String placeId}) {
    return reservationBookingStream
        .doc(placeId)
        .collection('reservation')
        .withConverter<Data>(
          fromFirestore: (snapshots, _) => Data.fromJson(snapshots.data()!),
          toFirestore: (snapshots, _) => snapshots.toJson(),
        );
  }

  ///How you actually get the stream of data from Firestore with the help of the previous function
  ///note that this query filters are for my data structure, you need to adjust it to your solution.
  Stream<QuerySnapshot<Data>> getBookingStreamFirebase(
      {required DateTime end, required DateTime start}) {
    return getBookingStream(placeId: 'reservation')
        .where('bookingStart', isGreaterThanOrEqualTo: start)
        .where('bookingStart', isLessThanOrEqualTo: end)
        .snapshots();
  }

  Future<dynamic> uploadBooking({required BookingService newBooking}) async {
    await reservation.add(newBooking.toJson()).then((value) {
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

  late List<DateTimeRange> converted = [];

  List<DateTimeRange> convertStreamResult({required dynamic streamResult}) {
    {
      final docRef = reservation.get();
      docRef.then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((DocumentSnapshot doc) {
          Map<String, dynamic> fireData = doc.data() as Map<String, dynamic>;
          final String reservationTime = fireData['bookingStart'];
          final DateTime parsedReservationTime =
              DateTime.parse(reservationTime);
          final reservationDate = fireData['bookingEnd'];
          final DateTime parsedReservationDate =
              DateTime.parse(reservationDate);
          final reservationWidget = DateTimeRange(
              start: parsedReservationTime, end: parsedReservationDate);
          return converted.add(reservationWidget);
        });
      });
    }
    return converted;
  }

  DateTime now = DateTime.now();
  late DateTime startDate = DateTime(now.year, now.month, now.day, 0);

  List<DateTimeRange> generatePauseSlots() {
    List<DateTimeRange> dateTimeRangeList = [];
    if (startDate.weekday != DateTime.saturday &&
        startDate.weekday != DateTime.sunday) {
      dateTimeRangeList
          .add(DateTimeRange(start: startDate, end: DateTime.now()));
    }
    return dateTimeRangeList;
  }

  @override
  void initState() {
    super.initState();
    reservationService = BookingService(
      serviceName: 'Reservation Service',
      serviceDuration: 120,
      bookingStart: DateTime(date.year, date.month, date.day, 8, 0),
      bookingEnd: DateTime(date.year, date.month, date.day, 16, 0),
      userId: _auth.currentUser!.uid,
    );

    /* addSaturday(itemsSaturday);
    addSunday(itemsSunday); */
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(5, 50, 5, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: isLoading
          ? const SpinKitChasingDots(
              color: Colors.black,
              duration: Duration(seconds: 3),
            )
          : BookingCalendar(
              bookingService: reservationService,
              getBookingStream: getBookingStreamFirebase,
              uploadBooking: uploadBooking,
              convertStreamResultToDateTimeRanges: convertStreamResult,
              bookingButtonText: 'SUBMIT',
              bookingButtonColor: kButtonColor,
              loadingWidget: const CustomLoadingWidget(),
              uploadingWidget: const CustomLoadingWidget(),
              startingDayOfWeek: StartingDayOfWeek.monday,
              bookingGridCrossAxisCount: 2,
              disabledDays: const [6, 7],
              pauseSlots: generatePauseSlots(),
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
