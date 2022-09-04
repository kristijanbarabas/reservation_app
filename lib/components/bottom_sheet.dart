import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reservation_app/data.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'package:reservation_app/constants.dart';

Data data = Data();

// creating our user
late User registeredUser;
//firestore instance
final _firestore = FirebaseFirestore.instance;
// DATE
DateTime date = DateTime.now();
CollectionReference reservationBookingStream = _firestore.collection('user');
CollectionReference reservation = _firestore
    .collection('user')
    .doc(registeredUser.uid)
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
  // drop down button value for time

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
        registeredUser = user;
        print(registeredUser.email);
      }
      isLoading = false;
    } catch (e) {
      Alert(context: context, title: "Error", desc: "Try again!").show();
    }
  }

  // booking service
  late BookingService mockBookingService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    mockBookingService = BookingService(
        serviceName: 'Reservation Service',
        serviceDuration: 120,
        bookingEnd: DateTime(date.year, date.month, date.day, 16, 0),
        bookingStart: DateTime(date.year, date.month, date.day, 8, 0));
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
    return getBookingStream(placeId: registeredUser.uid)
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

  late Map<String, dynamic> fireData = {};

  late List<DateTimeRange> converted = [];

  List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
    {
      final docRef = reservationList.get();
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
          return converted.add(reservationWidget);
        });
      });
    }
    print('this is : $converted');
    return converted;
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
                bookingService: mockBookingService,
                getBookingStream: getBookingStreamFirebase,
                uploadBooking: uploadBooking,
                convertStreamResultToDateTimeRanges: convertStreamResultMock,
                bookingButtonText: 'SUBMIT',
                bookingButtonColor: kButtonColor,
                loadingWidget: const Text('Fetching data...'),
                uploadingWidget: const Text('Uploading...'),
                startingDayOfWeek: StartingDayOfWeek.monday,
              ));
  }
}
