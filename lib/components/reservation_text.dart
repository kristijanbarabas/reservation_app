import 'package:flutter/material.dart';
import 'package:reservation_app/constants.dart';

class ReservationText extends StatelessWidget {
  const ReservationText({Key? key, required this.value, required this.label})
      : super(key: key);

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$label: $value',
      style: kReservationText,
    );
  }
}
