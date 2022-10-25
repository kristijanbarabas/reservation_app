import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:reservation_app/services/constants.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key});

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
