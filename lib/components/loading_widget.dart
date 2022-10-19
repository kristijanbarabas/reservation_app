import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:reservation_app/constants.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      backgroundColor: kBackgroundColor,
      content: Container(
        height: 100,
        color: kBackgroundColor,
        child: const SpinKitCircle(
          size: 100.0,
          color: kButtonColor,
          duration: Duration(seconds: 3),
        ),
      ),
    );
  }
}
