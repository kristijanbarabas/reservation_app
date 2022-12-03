import 'package:meta/meta.dart';

@immutable
class Reservations {
  final String? bookingStart;
  final String? bookingEnd;

  const Reservations({
    this.bookingStart,
    this.bookingEnd,
  });

  factory Reservations.fromMap(Map<String, dynamic>? data) {
    if (data == null) {
      throw StateError('missing data for user');
    }
    final bookingStart = data['bookingStart'] as String?;
    final bookingEnd = data['bookingEnd'] as String?;
    return Reservations(bookingStart: bookingStart, bookingEnd: bookingEnd);
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingStart': bookingStart,
      'bookingEnd': bookingEnd,
    };
  }
}
