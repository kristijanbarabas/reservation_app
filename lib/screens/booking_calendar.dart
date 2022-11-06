import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reservation_app/custom_widgets/loading_widget.dart';
import 'package:reservation_app/models/data.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'package:reservation_app/services/constants.dart';

//firestore instance
final _firestore = FirebaseFirestore.instance;

class CustomBookingCalendar extends StatefulWidget {
  static const String id = 'custom_booking_calendar';
  const CustomBookingCalendar({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomBookingCalendar> createState() => _CustomBookingCalendarState();
}

class _CustomBookingCalendarState extends State<CustomBookingCalendar> {
  // Our user
  late User loggedInUser;
  //

  // Firebase collection references
  CollectionReference reservationBookingStream = _firestore.collection('user');
  CollectionReference reservation = _firestore
      .collection('user')
      .doc('reservation')
      .collection('reservation');
  // Firebase auth
  final _auth = FirebaseAuth.instance;
  // bool
  bool isLoading = true;

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
  Stream<QuerySnapshot<Data>>? getBookingStreamFirebase(
      {required DateTime end, required DateTime start}) {
    return getBookingStream(placeId: 'reservation')
        .where('bookingStart', isGreaterThanOrEqualTo: start)
        .where('bookingStart', isLessThanOrEqualTo: end)
        .snapshots();
  }

  Future<dynamic> uploadBooking({required BookingService newBooking}) async {
    await reservation.add(newBooking.toJson()).then((value) {
      converted.add(DateTimeRange(
          start: newBooking.bookingStart, end: newBooking.bookingEnd));
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

  // Generated pause slots so the user can't pick a appointment that has passed - grey color
  List<DateTimeRange> generatePauseSlots() {
    List<DateTimeRange> dateTimeRangeList = [];
    if (startDate.weekday != DateTime.saturday &&
        startDate.weekday != DateTime.sunday) {
      dateTimeRangeList
          .add(DateTimeRange(start: startDate, end: DateTime.now()));
    }
    return dateTimeRangeList;
  }

  // A list containg all the reservations - it shows the booked(red color) appointments
  List<DateTimeRange> converted = [];
  void convertedHelperFunction() async {
    final documentReference = reservation.get();
    await documentReference.then(
      (QuerySnapshot snapshot) {
        snapshot.docs.forEach(
          (DocumentSnapshot documentSnapshot) {
            Map<String, dynamic> fireData =
                documentSnapshot.data() as Map<String, dynamic>;
            final String reservationTime = fireData['bookingStart'];
            final DateTime parsedReservationTime =
                DateTime.parse(reservationTime);
            final reservationDate = fireData['bookingEnd'];
            final DateTime parsedReservationDate =
                DateTime.parse(reservationDate);
            final reservationWidget = DateTimeRange(
                start: parsedReservationTime, end: parsedReservationDate);
            converted.add(reservationWidget);
            setState(() {
              isLoading = false;
            });
          },
        );
      },
    );
  }

  // List of booked appontiments required by the package
  List<DateTimeRange> convertedStreamResult({required dynamic streamResult}) {
    return converted;
  }

  @override
  void initState() {
    super.initState();
    reservationService = BookingService(
      serviceName: 'Reservation Service',
      serviceDuration: 120,
      bookingStart: DateTime(dateNow.year, dateNow.month, dateNow.day, 8, 0),
      bookingEnd: DateTime(dateNow.year, dateNow.month, dateNow.day, 16, 0),
      userId: _auth.currentUser!.uid,
    );
    convertedHelperFunction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: BookingCalendar(
          convertStreamResultToDateTimeRanges: convertedStreamResult,
          bookingService: reservationService,
          getBookingStream: getBookingStreamFirebase,
          uploadBooking: uploadBooking,
          bookingButtonText: 'SUBMIT',
          bookingButtonColor: kButtonColor,
          loadingWidget: const CustomLoadingWidget(),
          uploadingWidget: const CustomLoadingWidget(),
          startingDayOfWeek: StartingDayOfWeek.monday,
          bookingGridCrossAxisCount: 2,
          disabledDays: const [6, 7],
          pauseSlots: generatePauseSlots(),
        ),
      ),
    );
  }
}
