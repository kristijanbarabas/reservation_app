import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reservation_app/data.dart';
import 'package:reservation_app/screens/home.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'package:reservation_app/constants.dart';
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
  static const String id = 'custom_bottom_sheet';
  const CustomBookingCalendar({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomBookingCalendar> createState() => _CustomBookingCalendarState();
}

class _CustomBookingCalendarState extends State<CustomBookingCalendar> {
  // firebase auth
  final _auth = FirebaseAuth.instance;

  // FORM variables
  late Timestamp timestamp = Timestamp.fromDate(date);
  // bool
  bool isLoading = false;

  // method to check if the user is signed in
  void getCurrentUser() {
    isLoading = true;
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
      isLoading = false;
    } catch (e) {
      Alert(context: context, title: "Error", desc: "Try again!").show();
    }
  }

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
  Stream<dynamic>? getBookingStreamFirebase(
      {required DateTime end, required DateTime start}) {
    return getBookingStream(placeId: 'reservation')
        .where('bookingStart', isGreaterThanOrEqualTo: start)
        .where('bookingStart', isLessThanOrEqualTo: end)
        .snapshots();
  }

  Future<dynamic> uploadBooking({required BookingService newBooking}) async {
    await reservation.add(newBooking.toJson()).then((value) {
      Future.delayed(const Duration(seconds: 1));
      Alert(
        context: context,
        type: AlertType.success,
        title: "SUCCESS!",
        desc: "Your reservation has been added.",
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.pushNamed(context, HomeScreen.id);
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

  /*  final List itemsSaturday = List<DateTime>.generate(
      730,
      (i) => DateTime.utc(2022, DateTime.september, 1, 7, 0)
          .add(Duration(days: i)));

  final List itemsSunday = List<DateTime>.generate(
      730,
      (i) => DateTime.utc(2022, DateTime.september, 1, 16, 0)
          .add(Duration(days: i)));

  final List<DateTime> listSaturday = [];

  final List<DateTime> listSunday = [];

  addSaturday(items) {
    for (DateTime item in items) {
      if (item.weekday == DateTime.saturday) {
        listSaturday.add(item);
      }
    }
  }

  addSunday(items) {
    for (DateTime item in items) {
      if (item.weekday == DateTime.sunday) {
        listSunday.add(item);
      }
    }
  }

  List<DateTimeRange> generatePauseSlots() {
    List<DateTimeRange> dateTimeRangeList = [];
    for (final pairs in IterableZip([listSaturday, listSunday])) {
      dateTimeRangeList.add(DateTimeRange(start: pairs[0], end: pairs[1]));
    }
    return dateTimeRangeList;
  } */
  DateTime now = DateTime.now();
  late DateTime date = DateTime(now.year, now.month, now.day, 7);

  List<DateTimeRange> generatePauseSlots() {
    List<DateTimeRange> dateTimeRangeList = [];
    dateTimeRangeList.add(DateTimeRange(start: date, end: DateTime.now()));
    return dateTimeRangeList;
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    reservationService = BookingService(
      serviceName: 'Reservation Service',
      serviceDuration: 120,
      bookingStart: DateTime(date.year, date.month, date.day, 8, 0),
      bookingEnd: DateTime(date.year, date.month, date.day, 16, 0),
      userId: loggedInUser.uid,
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
              loadingWidget: const LinearProgressIndicator(),
              uploadingWidget: const LinearProgressIndicator(),
              startingDayOfWeek: StartingDayOfWeek.monday,
              bookingGridCrossAxisCount: 2,
              disabledDays: const [6, 7],
              pauseSlots: generatePauseSlots(),
            ),
    );
  }
}
