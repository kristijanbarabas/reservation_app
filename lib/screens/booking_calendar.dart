import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservation_app/custom_widgets/async_value_widget.dart';
import 'package:reservation_app/custom_widgets/loading_widget.dart';
import 'package:reservation_app/services/alerts.dart';
import 'package:reservation_app/services/booking_calendar_services.dart';
import 'package:reservation_app/services/firestore_path.dart';
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
  // Firebase authentification
  final _auth = FirebaseAuth.instance;
  // Booking service
  late BookingService bookingService;

  DateTime bookingStart() {
    DateTime? bookingStartDate = DateTime.now();
    if (bookingStartDate.weekday == DateTime.saturday) {
      bookingStartDate = DateTime(bookingStartDate.year, bookingStartDate.month,
          bookingStartDate.day + 2, 8, 0);
    } else if (bookingStartDate.weekday == DateTime.sunday) {
      bookingStartDate = DateTime(bookingStartDate.year, bookingStartDate.month,
          bookingStartDate.day + 1, 8, 0);
    } else {
      DateTime(bookingStartDate.year, bookingStartDate.month,
          bookingStartDate.day, 8, 0);
    }
    return bookingStartDate;
  }

  DateTime bookingEnd() {
    DateTime? bookingEndDate = DateTime.now();
    if (bookingEndDate.weekday == DateTime.saturday) {
      bookingEndDate = DateTime(bookingEndDate.year, bookingEndDate.month,
          bookingEndDate.day + 2, 16, 0);
    } else if (bookingEndDate.weekday == DateTime.sunday) {
      bookingEndDate = DateTime(bookingEndDate.year, bookingEndDate.month,
          bookingEndDate.day + 1, 16, 0);
    } else {
      DateTime(
          bookingEndDate.year, bookingEndDate.month, bookingEndDate.day, 16, 0);
    }
    return bookingEndDate;
  }

  @override
  void initState() {
    super.initState();
    bookingService = BookingService(
      serviceName: 'Reservation Service',
      serviceDuration: 120,
      bookingStart: bookingStart(),
      bookingEnd: bookingEnd(),
      userId: _auth.currentUser!.uid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Consumer(
          // TODO find a way to refactor this and move it to booking calendar services
          builder: (context, ref, child) {
            final convertedDateTimeRangeList = ref.watch(dateTimeRangeProvider);
            final bookingServicesProvider = ref.watch(bookingCalendarServices);
            final customAlerts = ref.watch(customAlertsProvider);
            Future<dynamic> uploadBooking(
                {required BookingService newBooking}) async {
              await FirestorePath.userReservationsPath()
                  .add(newBooking.toJson())
                  .whenComplete(() {
                customAlerts!.successAlertDialot(context: context);
              }).catchError((error) {
                customAlerts!.errorAlertDialog(context: context);
              });
            }

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
