import 'package:flutter/material.dart';
import 'package:reservation_app/constants.dart';

class ReservationDetails extends StatelessWidget {
  final String reservationTime;
  final String reservationDate;

  const ReservationDetails(
      {Key? key, this.reservationTime = '', this.reservationDate = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Time: $reservationTime',
                        style: kMainMenuFonts,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                      Text(
                        'Date: $reservationDate',
                        style: kMainMenuFonts,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                    child: const Icon(Icons.delete, color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
