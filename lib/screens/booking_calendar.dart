import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservation_app/custom_widgets/async_value_widget.dart';
import 'package:reservation_app/custom_widgets/loading_widget.dart';
import 'package:reservation_app/services/booking_calendar_services.dart';
import 'package:reservation_app/services/firestore_path.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:booking_calendar/booking_calendar.dart';
import 'package:reservation_app/services/constants.dart';

class CustomBookingCalendar extends ConsumerStatefulWidget {
  static const String id = 'custom_booking_calendar';
  const CustomBookingCalendar({
    Key? key,
  }) : super(key: key);

  @override
  CustomBookingCalendarState createState() => CustomBookingCalendarState();
}

class CustomBookingCalendarState extends ConsumerState<CustomBookingCalendar> {
  // TODO find a way to refactor this and move it to booking calendar services
  Future<dynamic> uploadBooking({required BookingService newBooking}) async {
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

  // Firebase authentification
  final _auth = FirebaseAuth.instance;
  // Booking service
  late BookingService bookingService;
  // Today
  DateTime dateNow = DateTime.now();

  @override
  void initState() {
    super.initState();
    bookingService = BookingService(
      serviceName: 'Reservation Service',
      serviceDuration: 120,
      bookingStart: DateTime(dateNow.year, dateNow.month, dateNow.day, 8, 0),
      bookingEnd: DateTime(dateNow.year, dateNow.month, dateNow.day, 16, 0),
      userId: _auth.currentUser!.uid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Consumer(
          builder: (context, ref, child) {
            final convertedDateTimeRangeList = ref.watch(dateTimeRangeProvider);
            final bookingServicesProvider = ref.watch(bookingCalendarServices);
            return AsyncValueWidget<List<DateTimeRange>>(
                value: convertedDateTimeRangeList,
                data: (data) {
                  final List<DateTimeRange> dateTimeRangeList =
                      convertedDateTimeRangeList.value!;
                  List<DateTimeRange> convertedDateTimeRange(
                      {required dynamic streamResult}) {
                    return dateTimeRangeList;
                  }

                  return BookingCalendar(
                    convertStreamResultToDateTimeRanges: convertedDateTimeRange,
                    bookingService: bookingService,
                    getBookingStream:
                        bookingServicesProvider!.getBookingStreamFirebase,
                    uploadBooking: uploadBooking,
                    bookingButtonText: 'SUBMIT',
                    bookingButtonColor: kButtonColor,
                    loadingWidget: const CustomLoadingWidget(),
                    uploadingWidget: const CustomLoadingWidget(),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    bookingGridCrossAxisCount: 2,
                    disabledDays: const [6, 7],
                    pauseSlots: bookingServicesProvider.generatePauseSlots(),
                  );
                });
          },
        ),
      ),
    );
  }
}
