import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reservation_app/data.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'package:reservation_app/constants.dart';

// creating our user
late User loggedInUser;
//firestore instance
final _firestore = FirebaseFirestore.instance;
// DATE
DateTime date = DateTime.now();
CollectionReference reservationBookingStream = _firestore.collection('user');
CollectionReference reservation = _firestore
    .collection('user')
    .doc(loggedInUser.uid)
    .collection('reservation');
CollectionReference reservationList =
    _firestore.collection('user').doc().collection('reservation');

class CustomBottomSheet extends StatefulWidget {
  const CustomBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
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
        print(loggedInUser.email);
      }
      isLoading = false;
    } catch (e) {
      Alert(context: context, title: "Error", desc: "Try again!").show();
    }
  }

  // booking service
  late BookingService reservationService;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    reservationService = BookingService(
      serviceName: 'Reservation Service',
      serviceDuration: 120,
      bookingStart: DateTime(date.year, date.month, date.day, 8, 0),
      bookingEnd: DateTime(date.year, date.month, date.day, 16, 0),
    );
    // getData();
  }

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
    return getBookingStream(placeId: loggedInUser.uid)
        .where('bookingStart', isGreaterThanOrEqualTo: start)
        .where('bookingStart', isLessThanOrEqualTo: end)
        .snapshots();
  }

  Future<dynamic> uploadBooking({required BookingService newBooking}) async {
    await reservation
        .add(newBooking.toJson())
        .then((value) => print('Booking added'))
        .catchError((error) => print('Failed to add booking: $error'));
    Navigator.pop(context);
  }

  late List<DateTimeRange> converted = [];

  List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
    {
      final docRef = reservation.get();
      docRef.then((QuerySnapshot snapshot) {
        final data = snapshot.docs.forEach((DocumentSnapshot doc) {
          Map<String, dynamic> fireData = doc.data() as Map<String, dynamic>;
          print('this is : $fireData');
          final String reservationTime = fireData['bookingStart'];
          final DateTime parsedReservationTime =
              DateTime.parse(reservationTime);
          final reservationDate = fireData['bookingEnd'];
          final DateTime parsedReservationDate =
              DateTime.parse(reservationDate);
          final reservationWidget = DateTimeRange(
              start: parsedReservationTime, end: parsedReservationDate);
          /* DateTime saturday = DateTime.saturday as DateTime;
          DateTime sunday = DateTime.saturday as DateTime;
          returnconverted.add(DateTimeRange(start: saturday, end: sunday)); */
          return converted.add(reservationWidget);
        });
      });
    }
    print('this is : $converted');
    return converted;
  }

  List<DateTimeRange> generatePauseSlots() {
    return [
      //SEPTEMBER
      DateTimeRange(
          start: DateTime(2022, 9, 3, 8, 0), end: DateTime(2022, 9, 4, 16, 0)),
      DateTimeRange(
          start: DateTime(2022, 9, 10, 8, 0),
          end: DateTime(2022, 9, 11, 16, 0)),
      DateTimeRange(
          start: DateTime(2022, 9, 17, 8, 0),
          end: DateTime(2022, 9, 18, 16, 0)),
      DateTimeRange(
          start: DateTime(2022, 9, 24, 8, 0),
          end: DateTime(2022, 9, 25, 16, 0)),
      //OCTOBER
      DateTimeRange(
          start: DateTime(2022, 10, 1, 8, 0),
          end: DateTime(2022, 10, 2, 16, 0)),
      DateTimeRange(
          start: DateTime(2022, 10, 8, 8, 0),
          end: DateTime(2022, 10, 9, 16, 0)),
      DateTimeRange(
          start: DateTime(2022, 10, 15, 8, 0),
          end: DateTime(2022, 10, 16, 16, 0)),
      DateTimeRange(
          start: DateTime(2022, 10, 22, 8, 0),
          end: DateTime(2022, 10, 23, 16, 0)),
      DateTimeRange(
          start: DateTime(2022, 10, 29, 8, 0),
          end: DateTime(2022, 10, 30, 16, 0)),
    ];
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
                convertStreamResultToDateTimeRanges: convertStreamResultMock,
                bookingButtonText: 'SUBMIT',
                bookingButtonColor: kButtonColor,
                loadingWidget: const LinearProgressIndicator(),
                uploadingWidget: const LinearProgressIndicator(),
                startingDayOfWeek: StartingDayOfWeek.monday,
                pauseSlots: generatePauseSlots(),
                hideBreakTime: false,
                bookingGridCrossAxisCount: 2,
              ));
  }
}
