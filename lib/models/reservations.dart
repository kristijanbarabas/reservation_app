import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:meta/meta.dart';

@immutable
class Reservations {
  /*
  final String? placeId;
  final String? serviceName;
  final int? serviceDuration;
  final int? servicePrice; */
  final String? bookingStart;
  final String? bookingEnd;
  /* final String? email;
  final String? phoneNumber;
  final String? placeAddress; */
  const Reservations({
    /* this.email,
      this.phoneNumber,
      this.placeAddress, */
    this.bookingStart,
    this.bookingEnd,
    /*  this.placeId,
      this.userId,
      this.serviceName,
      this.serviceDuration,
      this.servicePrice */
  });

  static DateTime timeStampToDateTime(Timestamp timestamp) {
    return DateTime.parse(timestamp.toDate().toString());
  }

  static Timestamp dateTimeToTimeStamp(DateTime? dateTime) {
    return Timestamp.fromDate(dateTime ?? DateTime.now()); //To TimeStamp
  }

  factory Reservations.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw StateError('missing data for user');
    }
    final bookingStart = data['bookingStart'] as String?;
    final bookingEnd = data['bookingEnd'] as String?;
    return Reservations(bookingStart: bookingStart, bookingEnd: bookingEnd);
  }
}
